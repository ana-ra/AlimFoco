//
//  EditMealView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 05/12/23.
//

import SwiftUI
import CloudKit

struct EditMealView: View {
    @EnvironmentObject private var model: ModelMeal
    @Environment(\.dismiss) private var dismiss
    @State private var editMode = EditMode.inactive
    @State var showPopup: Bool = false
    @State var isEditing = false
    @State private var isAddItemModalPresented = false
    @State var meals: [Meal]
    @State var selection: String = ""
    @State var addedItems = MealItemList()
    @State var mealTypes: [String]
    @State var meal: Meal
    
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
                                
//                                let newMeal = Meal(id: ObjectIdentifier(Meal.self), name: "", date: Date(), satisfaction: "", itens: items, weights: weights, mealType: selection, registered: 0)
                                meal.itens = items
                                meal.weights = weights
                                meal.mealType = selection
                                
                                Task {
//                                    try await model.addMeal(meal: newMeal)
                                    try await model.updateMeal(editedMeal: meal)
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
        .navigationTitle("Editar Refeição")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            for i in 0..<meal.itens.count {
                addedItems.addItem(item: MealItem(id: ObjectIdentifier(MealItem.self), alimento: meal.itens[i], weight: meal.weights[i]))
            }
            
            selection = meal.mealType
        })
    }
    
    func deleteNavigationLinks(at offsets: IndexSet) {
        addedItems.itens.remove(atOffsets: offsets)
        print(addedItems)
    }
}

//#Preview {
//    EditMealView()
//}
