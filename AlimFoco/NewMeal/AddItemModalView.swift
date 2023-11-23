//
//  AddItemModalView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 10/11/23.
//

import SwiftUI

struct AddItemModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var weight: String = ""
    @ObservedObject var meal: Meal
    @State var item: Alimento?
    @FocusState var isInputActive: Bool
    
    var body: some View {
        List {
            NavigationLink(destination: FilterView(selection: $item) ) {
                HStack {
                    Text("Item")
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if weight == "" || item == nil {
                    Button {
                
                    } label: {
                        Text("Adicionar")
                            .foregroundColor(.gray)
                    }
                }
                
                else if weight != "" {
                    if let item = item {
                        Button("Adicionar") {
                            meal.items.append(Item(name: item.nome, weight: Int(weight)!))
                            dismiss()
                        }
                    }
                }
            }
        }
        .navigationTitle("Adicionar Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddItemModalView(meal: Meal(name: "Almoço", items: []))
}
