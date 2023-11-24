//
//  EditItemView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 22/11/23.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State var weight: String = ""
    @Binding var addedItems: MealItemList
    @State var index: Int
    @State var item: MealItem
    @State var editedItem: Alimento = Alimento(codigo1: "", nome: "", codigo2: "", preparacao: "", kcal: "", proteina: "", lipidios: "", carboidratos: "", fibraAlimentar: "")
    @FocusState var isInputActive: Bool
    
    var body: some View {
        VStack {
            List {
                Section {
                    NavigationLink(destination: FilterView(selection: $editedItem) ) {
                        HStack {
                            Text("Alimento")
                            Spacer()
                            
                            if editedItem.nome == "" {
                                Text(item.name)
                            } else {
                                Text(editedItem.nome)
                            }

                        }
                    }
                    
                    HStack {
                        Text("Quantidade (g)")
                        TextField("0 g", text: $weight)
                        .keyboardType(.numberPad)
                        .focused($isInputActive)
                        .onSubmit {
                            print("Return key pressed")
                        }
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Concluído") {
                                    isInputActive = false
                                }
                            }
                        }
                    }
                }
                
                Section {
                    Button {
//                        for i in 0..<addedItems.itens{
//                            if let item = item {
//                                if meal.items[i].name == item.nome {
//                                    meal.items.remove(at: i)
//                                    break
//                                }
//                            }
//                        }
                        // insirar logica de apagar item
                        addedItems.itens.remove(at: index)
                        dismiss()
                    } label: {
                        Text("Apagar Item")
                            .foregroundStyle(.red)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if weight == "" {
                        Button {
                    
                        } label: {
                            Text("Concluído")
                                .foregroundColor(.gray)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    else if weight != "" && editedItem.nome != "" {
                        Button {
                            addedItems.editItem(index: index, newItem: editedItem, weight: weight)
                            dismiss()
                        } label: {
                            Text("Concluído")
                                .fontWeight(.semibold)
                        }
                    }
                    
                    else if weight != item.weight {
                        Button {
                            addedItems.itens[index].weight = weight
                            dismiss()
                        } label: {
                            Text("Concluído")
                                .fontWeight(.semibold)
                        }
                    }
                }
            }
            .navigationTitle("Editar Item")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear(perform: {
            weight = item.weight
        })
    }
    
    var formattedWeight: String {
        return "\(weight) g"
    }
}

//#Preview {
//    EditItemView(weight: "", meal: Meal(name: "Almoço", items: []))
//}
