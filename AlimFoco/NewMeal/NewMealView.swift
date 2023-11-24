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
    @State var refeicoes: [String]
    @State var selection: String = ""
    @State var addedItems = MealItemList()
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Picker("Refeição", selection: $selection) {
                        ForEach(refeicoes, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    if addedItems.itens != [] {
                        Section {
                            ForEach(addedItems.itens.indices, id: \.self) { index in
                                NavigationLink(destination: EditItemView(addedItems: $addedItems, index: index, item: addedItems.itens[index])) {
                                    VStack(alignment: .leading) {
                                        Text(addedItems.itens[index].name)
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
                                addedItems.changeMeal(meal: selection)
                                
                                for item in addedItems.itens {
                                    Task {
                                        try await model.addMealItem(mealItem: item)
                                    }
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
            selection = refeicoes[0]
        })
    }
    
    func deleteNavigationLinks(at offsets: IndexSet) {
        addedItems.itens.remove(atOffsets: offsets)
        print(addedItems)
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
        itens[index] = MealItem(id: ObjectIdentifier(MealItem.self), name: newItem.nome, weight: weight, codigo1: newItem.codigo1, codigo2: newItem.codigo2, preparacao: newItem.preparacao, kcal: newItem.kcal, proteina: newItem.proteina, lipidios: newItem.lipidios, carboidratos: newItem.carboidratos, fibra: newItem.fibraAlimentar, refeicao: itens[index].refeicao)
    }
    
    func changeMeal(meal: String) {
        for index in 0..<itens.count {
//            itens[index] = MealItem(id: ObjectIdentifier(MealItem.self), name: itens[index].name, weight: itens[index].weight, codigo1: itens[index].codigo1, codigo2: itens[index].codigo2, preparacao: itens[index].preparacao, kcal: itens[index].kcal, proteina: itens[index].proteina, lipidios: itens[index].lipidios, carboidratos: itens[index].carboidratos, fibra: itens[index].fibra, refeicao: meal)
            itens[index].refeicao = meal
        }
    }
}

//#Preview {
//    NewMealView(refeicoes: .constant(["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]))
//}
