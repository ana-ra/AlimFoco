//
//  NewMealView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 08/11/23.
//

import SwiftUI

struct NewMealView: View {
    @State private var isAddItemModalPresented = false
    @State private var selection = "Almoço"
    @State var meals = [
        Meals(name: "Café da Manhã", items: [Item(name: "Salada", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meals(name: "Colação", items: [Item(name: "Batata", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meals(name: "Almoço", items: [Item(name: "asd", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meals(name: "Lanche da Tarde", items: [Item(name: "ffff", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meals(name: "Jantar", items: [Item(name: "Curs", weight: 100), Item(name: "Peito de Frango", weight: 150)])
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Select a meal", selection: $selection) {
                    ForEach(meals, id: \.self.name) {
                        Text($0.name).tag($0.name)
                    }
                }
                
                Section(header: Text("Items")) {
                    ForEach(meals[0].items) { item in
                        NavigationLink(destination: NewMealView()) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .foregroundStyle(.black)
                                Text("\(item.weight) g")
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
        }
        .sheet(isPresented: $isAddItemModalPresented) {
            NavigationStack {
                AddItemModalView()
            }
        }
    }
    
    func deleteNavigationLinks(at offsets: IndexSet) {
        meals[0].items.remove(atOffsets: offsets)
    }
}

struct Meals: Identifiable {
    let id = UUID()
    let name: String
    var items: [Item]
    
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
