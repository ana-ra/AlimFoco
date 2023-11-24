//
//  EditItemView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 22/11/23.
//

import SwiftUI

struct EditItemView: View {
    @Environment(\.dismiss) private var dismiss
    @State var weight: String
    @ObservedObject var meal: Meal
    @State var item: Alimento?
    @FocusState var isInputActive: Bool
    
    var body: some View {
        VStack {
            List {
                Section {
                    NavigationLink(destination: FilterView(selection: $item) ) {
                        HStack {
                            Text("Alimento")
                            Spacer()
                            
                            if item == nil {
                                Text("Selecionar")
                                    .foregroundStyle(.gray)
                            } else {
                                if let item = item {
                                    Text(item.nome)
                                }
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
                        for i in 0..<meal.items.count {
                            if let item = item {
                                if meal.items[i].name == item.nome {
                                    meal.items.remove(at: i)
                                    break
                                }
                            }
                        }
                        
                        dismiss()
                    } label: {
                        Text("Apagar Item")
                            .foregroundStyle(.red)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if weight == "" || item == nil {
                        Button {
                    
                        } label: {
                            Text("Concluído")
                                .foregroundColor(.gray)
                                .fontWeight(.semibold)
                        }
                    }
                    
                    else if weight != "" {
                        if let item = item {
                            Button {
                                meal.items.append(Item(name: item.nome, weight: Int(weight)!))
                                dismiss()
                            } label: {
                                Text("Concluído")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Editar Item")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var formattedWeight: String {
        return "\(weight) g"
    }
}

#Preview {
    EditItemView(weight: "", meal: Meal(name: "Almoço", items: []))
}
