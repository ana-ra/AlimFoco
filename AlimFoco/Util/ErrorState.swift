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
    let buttonText: String?
    let action: () -> Void
    var meals: [Meal] {
        modelMeal.Meals
    }
    @State var mealTypes: [String] = ["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]
    
    var body: some View {
        VStack (alignment: .center) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
            
            Text(title)
                .font(.system(size: 17))
                .foregroundColor(.black)
            
            Text(description)
                .foregroundColor(.gray)
                .padding(.top, 8)
                .padding(.horizontal, 16)
                .multilineTextAlignment(.center)
            
            if(buttonText != nil) {
                NavigationLink(destination: NewMealView(meals: meals, mealTypes: $mealTypes)) {
                    Text(buttonText ?? "Carregar")
                        .fontWeight(.semibold)
                }.padding(.top, 8)
            }
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

