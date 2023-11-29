import Foundation
import CloudKit

enum RecordKeysMeals: String {
    case type = "Meal"
    case name
    case date
    case satisfaction
    case itens
    case weights
    case mealType
    case registered
}


struct Meal: CKRecordValueProtocol, Identifiable {
    var id: ObjectIdentifier
    var recordId: CKRecord.ID?
    var name: String
    var date: Date
    var satisfaction: String
    var itens: [String]
    var weights: [String]
    var mealType: String
    var registered: Int
    
    var record: CKRecord {
        let record = CKRecord(recordType: RecordKeysMeals.type.rawValue)
        record[RecordKeysMeals.name.rawValue] = name
        record[RecordKeysMeals.date.rawValue] = date
        record[RecordKeysMeals.itens.rawValue] = itens
        record[RecordKeysMeals.satisfaction.rawValue] = satisfaction
        record[RecordKeysMeals.weights.rawValue] = weights
        record[RecordKeysMeals.mealType.rawValue] = mealType
        record[RecordKeysMeals.registered.rawValue] = registered
        return record
    }
}


extension Meal: Hashable {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        lhs.recordId == rhs.recordId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension Meal {
    init?(record: CKRecord) {
        guard let name = record[RecordKeysMeals.name.rawValue] as? String,
              let date = record[RecordKeysMeals.date.rawValue] as? Date,
              let satisfaction = record[RecordKeysMeals.satisfaction.rawValue] as? String,
              let weights = record[RecordKeysMeals.weights.rawValue] as? [String],
              let itens = record[RecordKeysMeals.itens.rawValue] as? [String],
              let mealType = record[RecordKeysMeals.mealType.rawValue] as? String,
              let registered = record[RecordKeysMeals.registered.rawValue] as? Int else {
            return nil
        }
        self.init(id: ObjectIdentifier(Meal.self), recordId: record.recordID, name: name, date: date, satisfaction: satisfaction, itens: itens, weights: weights, mealType: mealType, registered: registered)
    }
}
