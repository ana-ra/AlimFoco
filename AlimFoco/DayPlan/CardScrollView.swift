//
//  CardScrollView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 09/11/23.
//
import SwiftUI
struct CardScrollView: View {
    var refeicao: String
    @EnvironmentObject private var model: Model
    var MealItems: [MealItem] {
        model.Mealitems
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 0) {
                VStack(alignment:.leading) {
                    ForEach(MealItems.indices){ index in
                        HStack {
                            VStack(alignment: .leading) {
                                if (MealItems[index].refeicao == refeicao) {
                                    Text("\(MealItems[index].name) ")
                                        .foregroundStyle(.black)
                                    Text("\(MealItems[index].weight) g")
                                        .foregroundStyle(.gray)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 4)
                            Spacer()
                        }
                        .frame(width: getWidth() / 1.3)
                        //                      if(food < foods.count - 1){
                        //                          Divider()
                        //                      }
                    }
                    .padding(.vertical, 10)
                    
                    Spacer()
                }
                .background(Color.secondary1)
                .cornerRadius(20)
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
  CardScrollView(refeicao: "Almoço")
}
