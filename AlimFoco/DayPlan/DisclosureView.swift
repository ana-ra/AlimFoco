//
//  DisclosureView.swift
//  AlimFoco
//
//  Created by Ana Laura Alves Cordeiro on 05/12/23.
//

import SwiftUI

struct DisclosureView: View {
    var meals: [Meal]
    @State var selectedMeal: String = ""
    @State var isSatisfactionSheetPresented = false
    @StateObject private var expansionHandler = ExpansionHandler<ExpandableSection>()
    @State var selectedDate = Date()
    @State var mealTypes = ["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]
    
    var body: some View {
        ForEach(mealTypes.indices) { index in
            let filteredMeals = meals.filter { meal in
                meal.mealType == mealTypes[index]
            }
            
            if !filteredMeals.isEmpty {
             
        DisclosureGroup(
            isExpanded: self.expansionHandler.isExpanded(.refeicao(mealTypes[index])),
            content: {
                CardScrollView(meals: filteredMeals)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                Button(action: {
                    selectedMeal = mealTypes[index]
                    isSatisfactionSheetPresented.toggle()
                }) {
                    HStack(alignment: .center, spacing: 4) {
                        Image(systemName: "note.text.badge.plus")
                            .foregroundColor(Color.white)
                        
                        Text("Registrar")
                            .foregroundColor(Color.white)
                        
                    }
                    .padding(.horizontal, 16)
                    .frame(width: getWidth() / 2.8, height: getHeight() / 20)
                    .background(Color(red: 0.05, green: 0.51, blue: 0.44))
                    .cornerRadius(14)
                }
                .padding(.vertical, 8)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                
            },
            label: {
                Text(mealTypes[index])
                    .fontWeight(.medium)
             }
        )
            .listRowSeparator(.hidden)
            .listRowBackground(Color(red: 0.95, green: 0.95, blue: 0.97))
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .sheet(isPresented: $isSatisfactionSheetPresented, content: {
                        RegisterSatisfactionSheetView(selectedDate: $selectedDate, meal: $selectedMeal).presentationDetents([.height(getHeight() / 3.5)])
                            .tint(Color.informationGreen).environmentObject(ModelMealType())
                    })
                
            }
        }
    }
    
}
    
    extension DisclosureView {
        class ExpansionHandler<T: Equatable>: ObservableObject {
            @Published private (set) var expandedItem: T?

            func isExpanded(_ item: T) -> Binding<Bool> {
                return Binding(
                    get: { item == self.expandedItem },
                    set: { self.expandedItem = $0 == true ? item : nil }
                )
            }

            func toggleExpanded(for item: T) {
                self.expandedItem = self.expandedItem == item ? nil : item
            }
        }
    }
    
    extension DisclosureView {
        enum ExpandableSection: Equatable {
            case refeicao(String)
        }
    }
    

#Preview {
    DisclosureView(meals: [Meal(id: ObjectIdentifier(Meal.self), name: "Opção A", date: Date(), satisfaction: "", itens: ["Arroz", "Feijão"], weights: ["20","30"], mealType: "Almoço", registered: 0), Meal(id: ObjectIdentifier(Meal.self), name: "Opção B", date: Date(), satisfaction: "", itens: ["Macarrao", "Ervilha"], weights: ["20","30"], mealType: "Almoço", registered: 0)])
}
