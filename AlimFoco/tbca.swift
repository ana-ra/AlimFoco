//
//  TBCA.swift
//
//
//  Created by Larissa Okabayashi on 24/10/23.
//

import Foundation


func readLocalJSONFile(forName name: String) -> Data? {
    do {
           if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
               let fileUrl = URL(fileURLWithPath: filePath)
               let data = try Data(contentsOf: fileUrl)
               return data
           }
       } catch {
           print("error: \(error)")
       }
       return nil
}

struct alimento: Codable {
    let codigo1: String
    let nome: String
    let codigo2: String
    let preparacao: String
    let kcal: String
    let proteina: String
    let lipidios: String
    let carboidratos: String
    let fibraAlimentar: String
}
struct sampleRecord: Codable {
    let alimentos: [alimento]
}

func parse(jsonData: Data) -> sampleRecord? {
    do {
        let decodedData = try JSONDecoder().decode(sampleRecord.self, from: jsonData)
        return decodedData
    } catch {
        print("error: \(error)")
    }
    return nil
}

