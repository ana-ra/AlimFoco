//
//  ErrorState.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 13/11/23.
//

import SwiftUI

struct ErrorState: View {
    @EnvironmentObject private var modelMeal: ModelMeal
    let image: String
    let title: String
    let description: String
    let buttonText: String
    let action: () -> Void
    var meals: [Meal] {
        modelMeal.Meals
    }
    @State var mealTypes: [String] = ["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]
    
    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100) // Ajustar o tamanho conforme necessário
        
        Text(title)
            .font(.system(size: 20))
            .fontWeight(.semibold)
            .foregroundColor(.gray)
        
        Text(description)
            .foregroundColor(.gray)
            .padding(.top, 8)
            .padding(.horizontal, 16)
            .multilineTextAlignment(.center)
        
//        Button(action: {
//            self.action()
//        }) {
//            Text(buttonText)
//                .foregroundColor(.accentColor)
//                .font(.system(size: 15))
//        }
//        .padding(.top, 8)
        
        NavigationLink(destination: NewMealView(meals: meals, mealTypes: $mealTypes)) {
            Text(buttonText)
        }
    }
}

#Preview {
    ErrorState(
        image: "nome_da_imagem",
        title: "Ops! Está vazio.",
        description: "Não há refeições a serem exibidas para este dia.",
        buttonText: "Criar nova refeição",
        action: {}
    )
}

