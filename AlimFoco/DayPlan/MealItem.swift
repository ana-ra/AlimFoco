import Foundation
import CloudKit

enum RecordKeys: String {
    case type = "MealItem"
    case name
    case carboidratos
    case codigo1
    case codigo2
    case fibra
    case kcal
    case lipidos
    case preparacao
    case proteina
    case refeicao
    case weight
}

struct MealItem: CKRecordValueProtocol, Identifiable {
    var id: ObjectIdentifier
    var recordId: CKRecord.ID?
    var name: String
    var weight: String
    var codigo1: String
    var codigo2: String
    var preparacao: String
    var kcal: String
    var proteina: String
    var lipidios: String
    var carboidratos: String
    var fibra: String
    var refeicao: String
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
        guard let name = record[RecordKeys.name.rawValue] as? String,
              let carboidratos = record[RecordKeys.carboidratos.rawValue] as? String,
              let codigo1 = record[RecordKeys.codigo1.rawValue] as? String,
              let codigo2 = record[RecordKeys.codigo2.rawValue] as? String,
              let fibra = record[RecordKeys.fibra.rawValue] as? String,
              let kcal = record[RecordKeys.kcal.rawValue] as? String,
              let lipidios = record[RecordKeys.lipidos.rawValue] as? String,
              let preparaco = record[RecordKeys.preparacao.rawValue] as? String,
              let proteina = record[RecordKeys.proteina.rawValue] as? String,
              let refeicao = record[RecordKeys.refeicao.rawValue] as? String,
              let weight = record[RecordKeys.weight.rawValue] as? String else {
            return nil
        }
        self.init(id: ObjectIdentifier(MealItem.self), recordId: record.recordID, name: name, weight: weight, codigo1: codigo1, codigo2: codigo2, preparacao: preparaco, kcal: kcal, proteina: proteina, lipidios: lipidios, carboidratos: carboidratos, fibra: fibra, refeicao: refeicao)
    }
}

extension MealItem {
    
    var record: CKRecord {
        let record = CKRecord(recordType: RecordKeys.type.rawValue)
        record[RecordKeys.name.rawValue] = name
        record[RecordKeys.weight.rawValue] = weight
        record[RecordKeys.codigo1.rawValue] = codigo1
        record[RecordKeys.codigo2.rawValue] = codigo2
        record[RecordKeys.preparacao.rawValue] = preparacao
        record[RecordKeys.kcal.rawValue] = kcal
        record[RecordKeys.proteina.rawValue] = proteina
        record[RecordKeys.lipidos.rawValue] = lipidios
        record[RecordKeys.carboidratos.rawValue] = carboidratos
        record[RecordKeys.fibra.rawValue] = fibra
        record[RecordKeys.refeicao.rawValue] = refeicao
        return record
    }
    
}
