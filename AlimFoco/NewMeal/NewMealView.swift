//
//  NewMealView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 08/11/23.
//

import SwiftUI

struct NewMealView: View {
    @EnvironmentObject private var model: Model
    @Environment(\.dismiss) private var dismiss
    @State private var editMode = EditMode.inactive
    @State var showPopup: Bool = false
    @State var isEditing = false
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
            ZStack {
                List {
                    Picker("Select a meal", selection: $selection) {
                        ForEach(meals, id: \.self) {
                            Text($0.name).tag($0.name)
                        }
                    }
                    
                    if !selection.items.isEmpty {
                        Section {
                            ForEach(selection.items) { item in
                                NavigationLink(destination: EditItemView(weight: String(item.weight), meal: selection, item: Alimento(codigo1: "", nome: item.name, codigo2: "", preparacao: "", kcal: "", proteina: "", lipidios: "", carboidratos: "", fibraAlimentar: ""))) {
                                    VStack(alignment: .leading) {
                                        Text(item.name)
                                            .foregroundStyle(.black)
                                        Text("\(item.weight) g")
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                           .onDelete(perform: deleteNavigationLinks)
                        } header: {
                            HStack {
                                Text("Items")
                                
                                Spacer()
                                
                                Button {
                                    withAnimation(.spring()) {
                                        isEditing.toggle()
                                        editMode = isEditing ? .active : .inactive
                                    }
                                } label: {
                                    let buttonText = isEditing ? "Done" : "Edit"
                                    Text(buttonText)
                                }
                            }
                        }
                        .headerProminence(.increased)
                    }
                    
                    Section {
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
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        if !showPopup {
                            Button {
                                withAnimation {
                                    showPopup.toggle()

                                    // fazer logica de cadastro de nova refeição
                                }
                            } label: {
                                Text("Register")
                            }
                        .padding()
                        }
                    }
                }
                .environment(\.editMode, $editMode)
                .opacity(showPopup ? 0.1 : 1)
                
                if showPopup {
                    NewMealPopUpView()
                        .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                dismiss()
                            }
                        })
                }
            }

        }
        .sheet(isPresented: $isAddItemModalPresented, onDismiss: {
            withAnimation {
                isEditing.toggle()
                isEditing.toggle()
            }
        }, content: {
            NavigationStack {
                AddItemModalView(meal: selection)
            }
        })
        .onAppear(perform: {
            selection = meals[0]
        })
        .navigationTitle("New Meal")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func deleteNavigationLinks(at offsets: IndexSet) {
        selection.items.remove(atOffsets: offsets)
        print(selection)
        print(selection.items)
    }
}

#Preview {
    NewMealView()
}
