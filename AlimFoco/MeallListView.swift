//
//  MealItemView.swift
//  AlimFoco
//
//  Created by Larissa Okabayashi on 31/10/23.

import SwiftUI

struct MealListView: View {
    
    let MealItems: [MealItem]
    @EnvironmentObject private var model: Model
    
    var body: some View {
        List {
            ForEach(MealItems, id: \.recordId) { MealItem in
                MealItemView(MealItem: MealItem, onUpdate: { editedMeal in
                    Task {
                        do {
                            try await model.updateMealItem(editedMealItem: editedMeal)
                        } catch {
                            print(error)
                        }
                    }
                })
            }.onDelete { indexSet in
                
                guard let index = indexSet.map({ $0 }).last else {
                    return
                }
                
                let MealItem = model.Mealitems[index]
                Task {
                    do {
                        try await model.deleteItem(MealItemToBeDeleted: MealItem)
                    } catch {
                        print(error)
                    }
                }
                
            }
        }
        
    }
}

struct MealListView_Previews: PreviewProvider {
    static var previews: some View {
        MealListView(MealItems: []).environmentObject(Model())
    }
}

