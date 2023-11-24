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
    ScrollView(.horizontal){
      HStack(spacing: 0) {
          Spacer()
          VStack(alignment:.leading) {
              ForEach(MealItems.indices){ index in
                  HStack {
                      VStack(alignment: .leading) {
                          if (MealItems[index].refeicao == refeicao){
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
                  //                      if(food < foods.count - 1){
                  //                          Divider()
                  //                         .padding(0)
                  //                    }
                }
                .frame(width:287)
            }
            .background(Color(red: 0, green: 0.48, blue: 1).opacity(0.1))
            .cornerRadius(20)
            .padding(20)
        }
      }
    }
  }

#Preview {
  CardScrollView(refeicao: "Almoço")
}
