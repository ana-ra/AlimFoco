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

struct Alimento: Codable, Hashable {
    let codigo1: String
    let nome: String
    let codigo2: String
    let preparacao: String
    let kcal: String
    let proteina: String
    let lipidios: String
    let carboidratos: String
    let fibraAlimentar: String
    
    static func preview() -> Alimento {
        Alimento(codigo1: "123", nome: "arroz", codigo2: "2243", preparacao: "preparacao", kcal: "123", proteina: "321", lipidios: "234", carboidratos: "554", fibraAlimentar: "2323")
    }
}

struct sampleRecord: Codable {
    let alimentos: [Alimento]
}

class foodListViewModel: ObservableObject {
    @Published var alimentos = [Alimento]()
    @Published var searchText: String = ""
    
    var filteredAlimentos: [Alimento] {
        guard !searchText.isEmpty else { return alimentos }
        let suggestions = alimentos.filter { alimento in
            alimento.nome.lowercased().contains(searchText.lowercased())
        }
        
        return suggestions
    }
    
    init() {
        let data = readLocalJSONFile(forName: "ibge")
        let sampleData = parse(jsonData: data!)
        
        if let sampleData {
            alimentos = sampleData.alimentos
            alimentos = getUniqueItems(alimentos)
        }
    }
    
    func getUniqueItems(_ arr: [Alimento]) -> [Alimento] {
        var uniqueItems = [Alimento]()
        
        for item in arr {
            if !uniqueItems.contains(where: {$0.nome == item.nome}) {
                uniqueItems.append(item)
            }
        }
        
        uniqueItems = uniqueItems.sorted { $0.nome < $1.nome }
        return uniqueItems
    }
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

