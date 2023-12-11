//
//  NewMealView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 08/11/23.
//

import SwiftUI

struct NewMealView: View {
    @EnvironmentObject private var model: ModelMeal
    @Environment(\.dismiss) private var dismiss
    @State private var editMode = EditMode.inactive
    @State var showPopup: Bool = false
    @State var isEditing = false
    @State private var isAddItemModalPresented = false
    @State var meals: [Meal]
    @State var selection: String = ""
    @State var mealTitle: String = ""
    @State var addedItems = MealItemList()
    @Binding var mealTypes: [String]
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    Section{
                        HStack {
                            Text("Título")
                            TextField("Insira o título da refeição", text: $mealTitle)
                        }
                    }
                    Section() {
                        Picker(selection: $selection, label: Text("Selecione")) {
                                            ForEach(mealTypes, id: \.self) {
                                                Text($0)
                                            }
                                        }
                                    }
                    
                    
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
                            
                            Button {
                                isAddItemModalPresented.toggle()
                            } label: {
                                HStack {
                                    Text("Adicionar Item")
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Image(systemName: "plus")
                                }
                            }
                            
                        } header: {
                            HStack {
                                Text("Itens")
                                
                                Spacer()
                                if addedItems.itens != [] {
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
                        }
                        .headerProminence(.increased)
                    
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                if mealTitle != "" && addedItems.itens != [] {
                                    var items: [String] = []
                                    var weights: [String] = []
                                    
                                    for item in addedItems.itens {
                                        items.append(item.alimento)
                                        weights.append(item.weight)
                                    }
                                    
                                    let newMeal = Meal(id: ObjectIdentifier(Meal.self), name: mealTitle, date: createDate(today: Date()), satisfaction: "", itens: items, weights: weights, mealType: selection, registered: 0)
                                    
                                    Task {
                                        try await model.addMeal(meal: newMeal)
                                    }
                                    
                                    withAnimation {
                                        showPopup.toggle()
                                        
                                    }
                                }
                            } label: {
                                if mealTitle != "" && addedItems.itens != [] {
                                    Text("Cadastrar")
                                        .fontWeight(.semibold)
                                } else {
                                    Text("Cadastrar")
                                        .foregroundColor( .gray)
                                }
                                
                            }
                            .padding()
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
        print(addedItems)
    }
    
    func createDate(today: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: today)
        components.year = 2000
        
        if let modifiedDate = Calendar.current.date(from: components) {
            return modifiedDate
        } else {
            return today
        }
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
