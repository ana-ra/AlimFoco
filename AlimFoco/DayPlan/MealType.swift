////
////  MealType.swift
////  AlimFoco
////
////  Created by Larissa Okabayashi on 30/11/23.
////
//
//import Foundation
//import CloudKit
//
//enum RecordKeysMealType: String {
//    case type = "MealType"
//    case name
//    case date
//    case fidelity
//    case registered
//}
//
//
//struct MealType: CKRecordValueProtocol, Identifiable {
//    var id: ObjectIdentifier
//    var recordId: CKRecord.ID?
//    var name: String
//    var date: Date
//    var fidelity: String
//    var registered: Int
//    
//    var record: CKRecord {
//        let record = CKRecord(recordType: RecordKeysMealType.type.rawValue)
//        record[RecordKeysMealType.name.rawValue] = name
//        record[RecordKeysMealType.date.rawValue] = date
//        record[RecordKeysMealType.fidelity.rawValue] = fidelity
//        record[RecordKeysMealType.registered.rawValue] = registered
//        return record
//    }
//}
//
//
//extension MealType: Hashable {
//    static func == (lhs: MealType, rhs: MealType) -> Bool {
//        lhs.recordId == rhs.recordId
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(name)
//    }
//}
//
//extension MealType {
//    init?(record: CKRecord) {
//        guard let name = record[RecordKeysMealType.name.rawValue] as? String,
//              let date = record[RecordKeysMealType.date.rawValue] as? Date,
//              let fidelity = record[RecordKeysMealType.fidelity.rawValue] as? String,
//              let registered = record[RecordKeysMealType.registered.rawValue] as? Int else {
//            return nil
//        }
//        self.init(id: ObjectIdentifier(MealType.self), recordId: record.recordID, name: name, date: date, fidelity: fidelity, registered: registered)
//    }
//}
//
