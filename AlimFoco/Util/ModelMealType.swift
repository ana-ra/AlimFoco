//
//  ModelMealType.swift
//  AlimFoco
//
//  Created by Larissa Okabayashi on 30/11/23.
//

import Foundation
import CloudKit

// AGGREGATE MODEL
@MainActor
class ModelMealType: ObservableObject {
    
    private var db = CKContainer.default().privateCloudDatabase
    @Published private var Dictionary: [CKRecord.ID: MealType] = [:]
    @Published var MealTypes: [MealType] = []
    
    func addMealType(mealType: MealType) async throws {
          let record = try await db.save(mealType.record)
          guard let mealType = MealType(record: record) else { return }
          Dictionary[mealType.recordId!] = mealType
    }
    
    func populateMealType() async throws {
        
        let query = CKQuery(recordType: RecordKeysMealType.type.rawValue, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        let result = try await db.records(matching: query)
        let records = result.matchResults.compactMap { try? $0.1.get() }
        
        records.forEach { record in
            Dictionary[record.recordID] = MealType(record: record)
        }
        
        MealTypes = Dictionary.values.compactMap { $0 }
    }
    
    func updateMealType(editedMealType: MealType) async throws {
        Dictionary[editedMealType.recordId!]?.registered = editedMealType.registered
        Dictionary[editedMealType.recordId!]?.fidelity = editedMealType.fidelity
        
        do {
            let record = try await db.record(for: editedMealType.recordId!)
            record[RecordKeysMealType.registered.rawValue] = editedMealType.registered
            record[RecordKeysMealType.fidelity.rawValue] = editedMealType.fidelity
            try await db.save(record)
        } catch {
            Dictionary[editedMealType.recordId!] = editedMealType
            print(error)
        }
    }

    
}


