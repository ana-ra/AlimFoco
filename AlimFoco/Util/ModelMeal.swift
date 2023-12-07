import Foundation
import CloudKit

// AGGREGATE MODEL
@MainActor
class ModelMeal: ObservableObject {
    
    private var db = CKContainer.default().privateCloudDatabase
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
            Dictionary[editedMeal.recordId!]?.registered = 1
            
            do {
                let record = try await db.record(for: editedMeal.recordId!)
                record[RecordKeysMeal.registered.rawValue] = 1
                try await db.save(record)
            } catch {
                Dictionary[editedMeal.recordId!] = editedMeal
                print(error)
            }
        }
    
}
