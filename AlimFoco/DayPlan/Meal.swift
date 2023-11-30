import Foundation
import CloudKit

enum RecordKeysMeal: String {
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
        let record = CKRecord(recordType: RecordKeysMealType.type.rawValue)
        record[RecordKeysMeal.name.rawValue] = name
        record[RecordKeysMeal.date.rawValue] = date
        record[RecordKeysMeal.itens.rawValue] = itens
        record[RecordKeysMeal.satisfaction.rawValue] = satisfaction
        record[RecordKeysMeal.weights.rawValue] = weights
        record[RecordKeysMeal.mealType.rawValue] = mealType
        record[RecordKeysMeal.registered.rawValue] = registered
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
        guard let name = record[RecordKeysMeal.name.rawValue] as? String,
              let date = record[RecordKeysMeal.date.rawValue] as? Date,
              let satisfaction = record[RecordKeysMeal.satisfaction.rawValue] as? String,
              let weights = record[RecordKeysMeal.weights.rawValue] as? [String],
              let itens = record[RecordKeysMeal.itens.rawValue] as? [String],
              let mealType = record[RecordKeysMeal.mealType.rawValue] as? String,
              let registered = record[RecordKeysMeal.registered.rawValue] as? Int else {
            return nil
        }
        self.init(id: ObjectIdentifier(Meal.self), recordId: record.recordID, name: name, date: date, satisfaction: satisfaction, itens: itens, weights: weights, mealType: mealType, registered: registered)
    }
}
