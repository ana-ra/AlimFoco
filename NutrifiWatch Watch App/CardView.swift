//
//  CardView.swift
//  NutrifiWatch Watch App
//
//  Created by Gustavo Sacramento on 24/11/23.
//

import SwiftUI

struct CardView: View {
    let refeicao: String
    let foods = [
        Food(name: "arroz", weight: 120),
        Food(name: "feijão", weight: 150),
        Food(name: "banana", weight: 200),
        Food(name: "ovo", weight: 100),
    ]
    
    var body: some View {
        TabView {
            ForEach(0..<4) { i in
                VStack(alignment: .leading) {
                    ForEach(0..<foods.count) { index in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(foods[index].name) ")
                                    .foregroundStyle(.black)
                                Text("\(foods[index].weight) g")
                                    .foregroundStyle(.gray)
                            }
                            
                            
                            Spacer()
                        }
                        
                        if index < foods.count - 1 {
                            Divider()
                        }
                    }
                    
                }
            }
            
        }
        .tabViewStyle(.verticalPage)
        .background(Color.white)
//        ScrollView(.horizontal, showsIndicators: false){
//            HStack {
//                ForEach(0..<4){ i in
//                    VStack(alignment:.leading) {
//                        ForEach(0 ..< foods.count){ food in
//                            HStack {
//                                VStack(alignment: .leading) {
//                                    Text("\(foods[food].name) ")
//                                        .foregroundStyle(.black)
//                                    Text("\(foods[food].weight) g")
//                                        .foregroundStyle(.gray)
//                                }
//                                Spacer()
//                            }
//                            
//                            if(food < foods.count - 1){
//                                Divider()
//                            }
//                        }
//                        .frame(width: getWidth() / 1.3)
//                    }
//                    .padding(.vertical, 10)
//                    
//                    Spacer()
//                }
//                .background(Color.secondary)
//                .cornerRadius(20)
//                .padding(.vertical, 4)
//            }
//        }
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
    CardView(refeicao: "Almoço")
}
