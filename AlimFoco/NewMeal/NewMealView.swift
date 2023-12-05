//
//  NewMealView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 08/11/23.
//

import SwiftUI

struct NewMealView: View {
//    @EnvironmentObject private var modelMealItem: Model
    @EnvironmentObject private var model: ModelMeal
    @Environment(\.dismiss) private var dismiss
    @State private var editMode = EditMode.inactive
    @State var showPopup: Bool = false
    @State var isEditing = false
//    var mealItems: [MealItem] {
//        model.Mealitems
//    }
    @State private var isAddItemModalPresented = false
    @State var meals: [Meal]
    @State var selection: String = ""
    @State var addedItems = MealItemList()
    @Binding var mealTypes: [String]
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Picker("Refeição", selection: $selection) {
                        ForEach(mealTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    if addedItems.itens != [] {
                        Section {
                            ForEach(addedItems.itens.indices, id: \.self) { index in
                                NavigationLink(destination: EditItemView(addedItems: $addedItems, index: index, item: addedItems.itens[index])) {
                                    VStack(alignment: .leading) {
                                        Text(addedItems.itens[index].alimento)
                                            .foregroundStyle(.black)
                                        Text("\(addedItems.itens[index].weight) g")
                                            .foregroundStyle(.gray)
                                    }
                                }
                            }
                           .onDelete(perform: deleteNavigationLinks)
                        } header: {
                            HStack {
                                Text("Itens")
                                
                                Spacer()
                                
                                Button {
                                    withAnimation(.spring()) {
                                        isEditing.toggle()
                                        editMode = isEditing ? .active : .inactive
                                    }
                                } label: {
                                    let buttonText = isEditing ? "OK" : "Editar"
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
                                Text("Adicionar Item")
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
                                var items: [String] = []
                                var weights: [String] = []
                                
                                for item in addedItems.itens {
                                    items.append(item.alimento)
                                    weights.append(item.weight)
                                }
                                
                                let newMeal = Meal(id: ObjectIdentifier(Meal.self), name: "", date: Date(), satisfaction: "", itens: items, weights: weights, mealType: selection, registered: 0)
                                
                                Task {
                                    try await model.addMeal(meal: newMeal)
                                }
                                
                                withAnimation {
                                    showPopup.toggle()

                                    // fazer logica de cadastro de nova refeição
                                }
                            } label: {
                                Text("Cadastrar")
                                    .fontWeight(.semibold)
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
                var aux = selection
                selection = ""
                selection = aux
            }
        }, content: {
            NavigationStack {
                AddItemModalView(selectedRefeicao: $selection, addedItems: $addedItems)
            }
        })
        .navigationTitle("Nova Refeição")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            selection = mealTypes[0]
        })
    }
    
    func deleteNavigationLinks(at offsets: IndexSet) {
        addedItems.itens.remove(atOffsets: offsets)
//        print(addedItems)
    }
}

class MealItemList {
    var itens: [MealItem]
    
    init() {
        itens = []
    }
    
    func addItem(item: MealItem) {
        itens.append(item)
    }
    
    func editItem(index: Int, newItem: Alimento, weight: String) {
        itens[index] = MealItem(id: ObjectIdentifier(MealItem.self), alimento: newItem.nome, weight: weight)
    }
}

//#Preview {
//    NewMealView(refeicoes: .constant(["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]))
//}
