import Foundation
import CloudKit

// AGGREGATE MODEL
@MainActor
class Model: ObservableObject {
    
    private var db = CKContainer.default().privateCloudDatabase
    @Published private var Dictionary: [CKRecord.ID: MealItem] = [:]
    
    var Mealitems: [MealItem] {
        Dictionary.values.compactMap { $0 }
    }

    func addMealItem(mealItem: MealItem) async throws {
        let record = try await db.save(mealItem.record)
        guard var meal = MealItem(record: record) else { return }
        Dictionary[meal.recordId!] = meal
    }
    
    func updateMealItem(editedMealItem: MealItem) async throws {
        
        Dictionary[editedMealItem.recordId!]?.items = editedMealItem.items
        
        do {
            let record = try await db.record(for: editedMealItem.recordId!)
            record[RecordKeys.items.rawValue] = editedMealItem.items
            try await db.save(record)
        } catch {
            Dictionary[editedMealItem.recordId!] = editedMealItem
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
        query.sortDescriptors = [NSSortDescriptor(key: "dateAssigned", ascending: false)]
        let result = try await db.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        records.forEach { record in
            Dictionary[record.recordID] = MealItem(record: record)
        }
    }
    
}
