//
//  NewMealView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 08/11/23.
//

import SwiftUI

struct NewMealView: View {
    @EnvironmentObject private var model: Model
    @State private var editMode = EditMode.inactive
    @State private var refreshView = false
    var mealItems: [MealItem] {
        model.Mealitems
    }
    @State private var isAddItemModalPresented = false
    @State private var selection: MealItem = MealItem(name: "", items: [])
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Select a meal", selection: $selection) {
                    ForEach(mealItems, id: \.self) {
                        Text($0.name).tag($0.name)
                    }
                }
                
                Section(header: Text("Items")) {
                    ForEach(selection.items) { item in
                        NavigationLink(destination: NewMealView()) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .foregroundStyle(.black)
                                Text("\(item.weight) g")
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                   .onDelete(perform: deleteNavigationLinks)
                }
                .headerProminence(.increased)
                
                Button {
                    // abrir o modal de adicionar item
                    isAddItemModalPresented.toggle()
                } label: {
                    HStack {
                        Text("Add Item")
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: "plus")
                    }
                }
            }
            .toolbar {
                EditButton()
            }
            .environment(\.editMode, $editMode)

        }
        .sheet(isPresented: $isAddItemModalPresented) {
            NavigationStack {
                AddItemModalView(refreshView: $refreshView, meal: selection)
                    .onAppear {
                        if refreshView {
                            print("View is refreshed!")
                            refreshView = false
                        }
                    }
            }
        }
        .onAppear(perform: {
            selection = mealItems[0]
        })
    }
    
    func deleteNavigationLinks(at offsets: IndexSet) {
//        var mealsList = meals
//        if let mealIndex = mealsList.lastIndex(of: selection) {
//            mealsList[mealIndex].items.remove(atOffsets: offsets)
//        }
//        meals = mealsList
//        var newSelection = selection
        selection.items.remove(atOffsets: offsets)
//     //   selection = newSelection
        print(selection)
        print(selection.items)
        for meal in mealItems {
            if meal == selection {
                for item in meal.items {
                    print(item)
                }
            }
        }
    }
}

#Preview {
    NewMealView()
}
