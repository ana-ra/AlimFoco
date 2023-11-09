//
//  CardScrollView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 09/11/23.
//
import SwiftUI
struct CardScrollView: View {
    let foods = [
        Food(name: "arroz"),
        Food(name: "feijão"),
        Food(name: "banana"),
        Food(name: "ovo"),
    ]
    
  var body: some View {
    ScrollView(.horizontal){
      HStack(spacing: 0) {
          Spacer()
          ForEach(0..<5){ i in
              VStack(alignment:.leading, spacing:0) {
                  ForEach(0 ..< foods.count){ food in
                      HStack {
                          Text("\(foods[food].name)")
                              .foregroundStyle(.black)
                          .padding(16)
                          Spacer()
                    }
                      if(food < foods.count - 1){
                          Divider()
                         .padding(0)
                    }
                  }
                  .frame(width:287)
                 
            }
          }
            .background(Color(red: 0, green: 0.48, blue: 1).opacity(0.1))
            .cornerRadius(20)
            .padding(20)
        }
      }
    }
  }


struct Food: Identifiable {
    let id = UUID()
    let name: String
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
