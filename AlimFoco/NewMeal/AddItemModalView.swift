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
    @FocusState var isInputActive: Bool
    @Binding var selectedRefeicao: String
    @State var item: Alimento = Alimento(codigo1: "", nome: "", codigo2: "", preparacao: "", kcal: "", proteina: "", lipidios: "", carboidratos: "", fibraAlimentar: "")
    var MealItems: [MealItem] {
        model.Mealitems
    }
    @Binding var addedItems: MealItemList
    
    var body: some View {
        List {
            NavigationLink(destination: FilterView(selection: $item) ) {
                HStack {
                    Text("Item")
                    Spacer()
                    
                    if item.nome == "" {
                        Text("Selecionar")
                            .foregroundStyle(.gray)
                    } else {
                        Text(item.nome)
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
                if weight == "" || item.nome == "" {
                    Button {
                
                    } label: {
                        Text("Adicionar")
                            .foregroundColor(.gray)
                    }
                }
                
                if weight != "" && item.nome != "" {
                    Button("Adicionar") {
                        let newItem: MealItem = MealItem(id: ObjectIdentifier(MealItem.self), alimento: item.nome, weight: weight)
//                        Task{
//                            try await model.addMealItem(mealItem: meal)
//                        }
                        
                        print(newItem)
                        addedItems.addItem(item: newItem)
                        dismiss()
                    }
                }
            }
        }
        .navigationTitle("Adicionar Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    AddItemModalView(selectedRefeicao: .constant("Almoço", addedItems: .constant(MealItemList())))
//}
