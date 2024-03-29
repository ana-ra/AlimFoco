import Foundation
import CloudKit

// AGGREGATE MODEL
@MainActor
class ModelMeal: ObservableObject {
    
    private var container = CKContainer.default()
    private lazy var db = container.privateCloudDatabase
    
    @Published private var Dictionary: [CKRecord.ID: Meal] = [:]
    @Published var Meals: [Meal] = []
    
    func addMeal(meal: Meal) async throws {
        let record = try await db.save(meal.record)
        guard let meal = Meal(record: record) else { return }
        Dictionary[meal.recordId!] = meal
    }
    
    func populateMeals() async throws {
        
        let query = CKQuery(recordType: RecordKeysMeal.type.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let result = try await db.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        records.forEach { record in
            Dictionary[record.recordID] = Meal(record: record)
        }
        
        Meals = Dictionary.values.compactMap { $0 }
    }
    
    func updateMeal(editedMeal: Meal) async throws {
        Dictionary[editedMeal.recordId!]?.registered = editedMeal.registered
        Dictionary[editedMeal.recordId!]?.itens = editedMeal.itens
        Dictionary[editedMeal.recordId!]?.weights = editedMeal.weights
        Dictionary[editedMeal.recordId!]?.mealType = editedMeal.mealType
        
        do {
            let record = try await db.record(for: editedMeal.recordId!)
            record[RecordKeysMeal.registered.rawValue] = editedMeal.registered
            record[RecordKeysMeal.itens.rawValue] = editedMeal.itens
            record[RecordKeysMeal.weights.rawValue] = editedMeal.weights
            record[RecordKeysMeal.mealType.rawValue] = editedMeal.mealType
            try await db.save(record)
        } catch {
            Dictionary[editedMeal.recordId!] = editedMeal
            print(error)
            // throw an error to tell the user that something has happened and the update was not successfull
        }
    }
    
    func deleteMeal(MealToBeDeleted: Meal) async throws {
        Dictionary.removeValue(forKey: MealToBeDeleted.recordId!)
        
        do {
            let _ = try await db.deleteRecord(withID: MealToBeDeleted.recordId!)
        } catch {
            Dictionary[MealToBeDeleted.recordId!] = MealToBeDeleted
            print(error)
        }
    }
    
    func login() async -> AccountStatus {
        await withCheckedContinuation { continuation in
            container.accountStatus { status, error in
                if let error = error {
                    print("Erro ao verificar o status da conta: \(error)")
                    continuation.resume(returning: .couldNotDetermine)
                } else {
                    switch status {
                    case .available:
                        print("Usuário logado no iCloud")
                        continuation.resume(returning: .available)
                    case .noAccount:
                        print("Usuário não está logado no iCloud")
                        continuation.resume(returning: .noAccount)
                    case .restricted, .couldNotDetermine:
                        print("Status da conta iCloud restrito ou indeterminado")
                        continuation.resume(returning: .restricted)
                    @unknown default:
                        print("Status da conta desconhecido")
                        continuation.resume(returning: .couldNotDetermine)
                    }
                }
            }
        }
    }
}

enum AccountStatus {
    case available
    case noAccount
    case restricted
    case couldNotDetermine
    case unknown
}
