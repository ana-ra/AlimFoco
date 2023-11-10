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
    
    var body: some View {
        List {
            NavigationLink(destination: NewMealView()) {
                HStack {
                    Text("Item")
                    Spacer()
                    Text("Select")
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
    AddItemModalView()
}
