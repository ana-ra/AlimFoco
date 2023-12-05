//
//  EmptyState.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 30/11/23.
//

import SwiftUI

struct EmptyState: View {
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
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                Spacer()
            }
            
            Text(title)
                .font(.system(size: 17))
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.top, 32)
            
            Text(description)
                .foregroundColor(.gray)
                .padding(.top, 8)
            
            
            if(buttonText != nil) {
                NavigationLink(destination: NewMealView(meals: meals, mealTypes: $mealTypes)) {
                    HStack(alignment: .center) {
                        Text("Adicionar Refeição")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(Color.teal)
                    .cornerRadius(12)
                }.padding(.top, 28)
            }
            
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity, alignment: .top)
        .background(.white)
        
        .cornerRadius(10)
    }
}

#Preview {
    EmptyState(image: "", title: "", description: "", buttonText: "", action: {})
}
