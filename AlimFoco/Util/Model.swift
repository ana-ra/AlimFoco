import Foundation
import CloudKit

// AGGREGATE MODEL
@MainActor
class Model: ObservableObject {
    
    private var db = CKContainer.default().privateCloudDatabase
    @Published private var Dictionary: [CKRecord.ID: MealItem] = [:]
    @Published var Mealitems: [MealItem] = []
    
    func addMealItem(mealItem: MealItem) async throws {
          let record = try await db.save(mealItem.record)
          guard let meal = MealItem(record: record) else { return }
          Dictionary[meal.recordId!] = meal
      }
      
    func updateMealItem(editedMealItem: MealItem) async throws {
        
        Dictionary[editedMealItem.recordId!]?.carboidratos = editedMealItem.carboidratos
        Dictionary[editedMealItem.recordId!]?.codigo1 = editedMealItem.codigo1
        Dictionary[editedMealItem.recordId!]?.codigo2 = editedMealItem.codigo2
        Dictionary[editedMealItem.recordId!]?.fibra = editedMealItem.fibra
        Dictionary[editedMealItem.recordId!]?.kcal = editedMealItem.kcal
        Dictionary[editedMealItem.recordId!]?.lipidios = editedMealItem.lipidios
        Dictionary[editedMealItem.recordId!]?.name = editedMealItem.name
        Dictionary[editedMealItem.recordId!]?.preparacao = editedMealItem.preparacao
        Dictionary[editedMealItem.recordId!]?.proteina = editedMealItem.proteina
        Dictionary[editedMealItem.recordId!]?.refeicao = editedMealItem.refeicao
        
        do {
            let record = try await db.record(for: editedMealItem.recordId!)
            record[RecordKeys.name.rawValue] = editedMealItem.name
            record[RecordKeys.weight.rawValue] = editedMealItem.weight
            record[RecordKeys.codigo1.rawValue] = editedMealItem.codigo1
            record[RecordKeys.codigo2.rawValue] = editedMealItem.codigo2
            record[RecordKeys.preparacao.rawValue] = editedMealItem.preparacao
            record[RecordKeys.kcal.rawValue] = editedMealItem.kcal
            record[RecordKeys.proteina.rawValue] = editedMealItem.proteina
            record[RecordKeys.lipidos.rawValue] = editedMealItem.lipidios
            record[RecordKeys.carboidratos.rawValue] = editedMealItem.carboidratos
            record[RecordKeys.fibra.rawValue] = editedMealItem.fibra
            record[RecordKeys.refeicao.rawValue] = editedMealItem.refeicao
            try await db.save(record)
        } catch {
            Dictionary[editedMealItem.recordId!] = editedMealItem
            print(error)
            // throw an error to tell the user that something has happened and the update was not successfull
        }
    }
    
    func deleteItem(MealItemToBeDeleted: MealItem) async throws {
        
        Dictionary.removeValue(forKey: MealItemToBeDeleted.recordId!)
        
        do {
            let _ = try await db.deleteRecord(withID: MealItemToBeDeleted.recordId!)
        } catch {
            Dictionary[MealItemToBeDeleted.recordId!] = MealItemToBeDeleted
            print(error)
        }
        
    }
    
    func populateMealItems() async throws {
        
        let query = CKQuery(recordType: RecordKeys.type.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let result = try await db.records(matching: query)
        print(result)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        records.forEach { record in
            Dictionary[record.recordID] = MealItem(record: record)
        }
        
        Mealitems = Dictionary.values.compactMap { $0 }
    }
    
}
