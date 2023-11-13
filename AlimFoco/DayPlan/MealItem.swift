import Foundation
import CloudKit

enum RecordKeys: String {
    case type = "MealItem"
    case title
    case dateAssigned
    case isCompleted
}

struct MealItem {
    
    var recordId: CKRecord.ID?
    let title: String
    let dateAssigned: Date
    var isCompleted: Bool = false
    
}

extension MealItem {
    init?(record: CKRecord) {
        guard let title = record[RecordKeys.title.rawValue] as? String,
              let dateAssigned = record[RecordKeys.dateAssigned.rawValue] as? Date,
              let isCompleted = record[RecordKeys.isCompleted.rawValue] as? Bool else {
            return nil
        }
        
        self.init(recordId: record.recordID, title: title, dateAssigned: dateAssigned, isCompleted: isCompleted)
    }
}

extension MealItem {
    
    var record: CKRecord {
        let record = CKRecord(recordType: RecordKeys.type.rawValue)
        record[RecordKeys.title.rawValue] = title
        record[RecordKeys.dateAssigned.rawValue] = dateAssigned
        record[RecordKeys.isCompleted.rawValue] = isCompleted
        return record
    }
    
}
