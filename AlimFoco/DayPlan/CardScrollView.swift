//
//  CardScrollView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 09/11/23.
//
import SwiftUI
struct CardScrollView: View {
    var meals: [Meal]
    @EnvironmentObject private var model: ModelMeal
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 0) {
                VStack(alignment:.leading) {
                    ForEach(meals, id: \.self){ meal in
                        ForEach(meal.itens.indices) { itemIndex in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(meal.itens[itemIndex]) ")
                                        .foregroundStyle(.black)
                                    Text("\(meal.weights[itemIndex]) g")
                                        .foregroundStyle(.gray)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 4)
                                Spacer()
                            }
                            .frame(width: getWidth() / 1.3)
                        }
                        //                      if(food < foods.count - 1){
                        //                          Divider()
                        //                      }
                    }
                    .padding(.vertical, 4)
                    
                    Spacer()
                }
                .background(Color.secondary1)
                .cornerRadius(20)
                .padding(.vertical, 4)
            }
        }
    }
}

//#Preview {
//  CardScrollView(meals)
//}
