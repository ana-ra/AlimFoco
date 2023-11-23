//
//  CardScrollView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 09/11/23.
//
import SwiftUI
struct CardScrollView: View {
    let foods = [
        Food(name: "arroz", weight: 120),
        Food(name: "feijão", weight: 150),
        Food(name: "banana", weight: 200),
        Food(name: "ovo", weight: 100),
    ]
    
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false){
      HStack(spacing: 0) {
          ForEach(0..<4){ i in
              VStack(alignment:.leading) {
                  ForEach(0 ..< foods.count){ food in
                      HStack {
                          VStack(alignment: .leading) {
                              Text("\(foods[food].name) ")
                                  .foregroundStyle(.black)
                              Text("\(foods[food].weight) g")
                                  .foregroundStyle(.gray)
                          }

                          .padding(.horizontal, 16)
                          .padding(.vertical, 4)
                          Spacer()
                      }
                      
                      if(food < foods.count - 1){
                          Divider()
                      }
                  }
                  .frame(width: getWidth() / 1.3)
            }
              .padding(.vertical, 10)
            
            Spacer()
          }
            .background(Color(red: 0, green: 0.48, blue: 1).opacity(0.1))
            .cornerRadius(20)
            .padding(.vertical, 4)
        }
      }
    }
  }



struct Food: Identifiable {
    let id = UUID()
    let name: String
    let weight: Int
}

struct FoodRow: View {
    var food: Food
    var body: some View {
            Text("\(food.name)")
    }
}

#Preview {
  CardScrollView()
}
