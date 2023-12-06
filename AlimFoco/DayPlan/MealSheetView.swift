//
//  MealSheetView.swift
//  AlimFoco
//
//  Created by Ana Laura Alves Cordeiro on 05/12/23.
//

import SwiftUI

struct MealSheetView: View {
    var meal: Meal
    
    var body: some View {
        List{
            ForEach(meal.itens.indices, id: \.self) { itemIndex in
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(meal.itens[itemIndex])")
                    Text("\(meal.weights[itemIndex]) g")
                        .foregroundColor(.gray) // Cor cinza padrão para os pesos
                }
            }
        }
         
        
    }
}

#Preview {
    MealSheetView(meal: Meal(id: ObjectIdentifier(Meal.self), name: "Opção A", date: Date(), satisfaction: "", itens: ["Arroz", "Feijão"], weights: ["20","30"], mealType: "Almoço", registered: 0))
}
