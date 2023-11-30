import Foundation
import CloudKit

enum RecordKeys: String {
    case type = "MealItem"
    case alimento
    case weight
}

struct MealItem: CKRecordValueProtocol, Identifiable {
    var id: ObjectIdentifier
    var recordId: CKRecord.ID?
    var alimento: String
    var weight: String
}

extension MealItem: Hashable {
    static func == (lhs: MealItem, rhs: MealItem) -> Bool {
        lhs.recordId == rhs.recordId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(alimento)
    }
}

extension MealItem {
    init?(record: CKRecord) {
        guard let alimento = record[RecordKeys.alimento.rawValue] as? String,
              let weight = record[RecordKeys.weight.rawValue] as? String else {
            return nil
        }
        self.init(id: ObjectIdentifier(MealItem.self), recordId: record.recordID, alimento: alimento, weight: weight)
    }
}

extension MealItem {
    
    var record: CKRecord {
        let record = CKRecord(recordType: RecordKeys.type.rawValue)
        record[RecordKeys.alimento.rawValue] = alimento
        record[RecordKeys.weight.rawValue] = weight
        return record
    }
    
}
