//
//  AddItemModalView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 10/11/23.
//

import SwiftUI

struct AddItemModalView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var weight: Int = 0
    @ObservedObject var meal: Meal
    @Binding var refreshView: Bool
    
    var body: some View {
        List {
            NavigationLink(destination: FilterView() ) {
                HStack {
                    Text("Item")
                    Spacer()
                    Text("Select")
                        .foregroundStyle(.gray)
                }
            }
            
            HStack {
                Text("Weight")
                TextField("Enter the text in grams", text: Binding(
                        get: { "\(weight) g"},
                        set: {
                            if let value = NumberFormatter().number(from: $0) {
                                weight = Int(value)
                            }
                        }
                ))
                .keyboardType(.numberPad)
                .onSubmit {
                    print("Return key pressed")
                }
            }

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add") {
                    meal.items.append(Item(name: "New Item", weight: weight))
                    refreshView = true
                    dismiss()
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
