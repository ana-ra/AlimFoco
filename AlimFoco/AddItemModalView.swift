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
    @Binding var refreshView: Bool
    @State var item: Alimento?
    @FocusState var isInputActive: Bool
    
    var body: some View {
        List {
            NavigationLink(destination: FilterView(selection: $item) ) {
                HStack {
                    Text("Item")
                    Spacer()
                    
                    if item == nil {
                        Text("Select")
                            .foregroundStyle(.gray)
                    } else {
                        if let item = item {
                            Text(item.nome)
                        }
                    }

                }
            }
            
            HStack {
                Text("Weight (g)")
                TextField("Enter the text in grams", text: $weight)
                .keyboardType(.numberPad)
                .focused($isInputActive)
                .onSubmit {
                    print("Return key pressed")
                }
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") {
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
                        Text("Add")
                            .foregroundColor(.gray)
                    }
                }
                
                else if weight != "" {
                    if let item = item {
                        Button("Add") {
                            meal.items.append(Item(name: item.nome, weight: Int(weight)!))
                            refreshView = true
                            dismiss()
                        }
                    }
                }
            }
        }
        .navigationTitle("Add Item")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var formattedWeight: String {
        return "\(weight) g"
    }
}

#Preview {
    AddItemModalView(meal: Meal(name: "Almoço", items: []), refreshView: .constant(false))
}
