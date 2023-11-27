//
//  ContentView.swift
//  NutrifiWatch Watch App
//
//  Created by Gustavo Sacramento on 24/11/23.
//

import SwiftUI

struct ContentView: View {
    let refeicoes = ["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(refeicoes, id: \.self) { refeicao in
                    NavigationLink(destination: CardView(refeicao: refeicao)) {
                        Text(refeicao)
                    }
                }
            }
            .navigationTitle("Refeições")
        }
    }
}

#Preview {
    ContentView()
}
