//
//  AddItemModalView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 10/11/23.
//

import SwiftUI

struct AddItemModalView: View {
    @EnvironmentObject private var model: Model
    @Environment(\.dismiss) private var dismiss
    @State private var weight: String = ""
    @Binding var refreshView: Bool
    @State var item: Alimento?
    @FocusState var isInputActive: Bool
    @State var meal: MealItem
    var MealItems: [MealItem] {
        model.Mealitems
    }
    
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
                            Task{
                                do{
                                    meal.items = [Item(name: item.nome, weight: Int(weight)!)]
                                    try await model.updateMealItem(editedMealItem: meal)
                                } catch {
                                    print(error)
                                }
                            }
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
    AddItemModalView(refreshView: .constant(false), meal: MealItem(name: "Almoço", items: []))
}
