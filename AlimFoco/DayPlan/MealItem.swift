import Foundation
import CloudKit
                            
struct Item: Identifiable, CKRecordValueProtocol {
    var id = UUID()
    var name: String
    var weight: Int
      
    init(name: String, weight: Int) {
        self.name = name
        self.weight = weight
    }
}

enum RecordKeys: String {
    case type = "MealItem"
    case name
    case items
}

struct MealItem {
    var recordId: CKRecord.ID?
    var name: String
    var items: [Item]
}

extension MealItem: Hashable {
    static func == (lhs: MealItem, rhs: MealItem) -> Bool {
        lhs.recordId == rhs.recordId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}

extension MealItem {
    init?(record: CKRecord) {
        guard var name = record[RecordKeys.name.rawValue] as? String,
              var items = record[RecordKeys.items.rawValue] as? [Item] else {
            return nil
        }
        
        self.init(recordId: record.recordID, name: name, items: items)
    }
}

extension MealItem {
    
    var record: CKRecord {
        var record = CKRecord(recordType: RecordKeys.type.rawValue)
        record[RecordKeys.name.rawValue] = name
        record[RecordKeys.items.rawValue] = items
        return record
    }
    
}
