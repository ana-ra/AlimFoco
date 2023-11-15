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
    @State private var selection: Meal = Meal(name: "", items: [])
    @State var meals = [
        Meal(name: "Café da Manhã", items: [Item(name: "Salada", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meal(name: "Colação", items: []),
        Meal(name: "Almoço", items: [Item(name: "asd", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meal(name: "Lanche da Tarde", items: [Item(name: "ffff", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meal(name: "Jantar", items: [Item(name: "Curs", weight: 100), Item(name: "Peito de Frango", weight: 150)])
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Select a meal", selection: $selection) {
                    ForEach(meals, id: \.self) {
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
                AddItemModalView(meal: selection, refreshView: $refreshView)
                    .onAppear {
                        if refreshView {
                            print("View is refreshed!")
                            refreshView = false
                        }
                    }
            }
        }
        .onAppear(perform: {
            selection = meals[0]
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
        for meal in meals {
            if meal == selection {
                for item in meal.items {
                    print(item)
                }
            }
        }
    }
}

class Meal: ObservableObject, Identifiable, Hashable {
    
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String {
        name
    }
    let name: String
    @Published var items: [Item]
    
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
}

struct Item: Identifiable {
    let id = UUID()
    var name: String
    let weight: Int
    
    init(name: String, weight: Int) {
        self.name = name
        self.weight = weight
    }
}

#Preview {
    NewMealView()
}
