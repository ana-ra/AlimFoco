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
    @State var filteredMealsState: [Meal] = []
    @State var mealTypes = ["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]
    
    var body: some View {
        List{
            Section(header: Text("Próximas Refeições")) {
                if verifyRegister(n: 0) {
                    HStack{
                        Text("Todas as refeições do dia foram registradas")
                    }.padding( 8)
                        .background(Color.white)
                        .cornerRadius(14)
                } else {
                    ForEach(mealTypes.indices) { index in
                        let filteredMeals = meals.filter { meal in
                            meal.mealType == mealTypes[index] && meal.registered == 0
                        }
                        if !filteredMeals.isEmpty {
                            DisclosureGroup (isExpanded: self.expansionHandler.isExpanded(.refeicao(mealTypes[index])),
                                             content: {
                                CardScrollView(meals: filteredMeals)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                Button(action: {
                                    filteredMealsState = filteredMeals
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
                                    .background(Color(.teal))
                                    .cornerRadius(14)
                                }
                                .padding(.vertical, 8)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                               
                            }, label: {
                                Text(mealTypes[index])
                                    .fontWeight(.semibold)
                            }
                            )
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 50, leading: 20, bottom: 20, trailing: 10))
                        }
                    }
                }
                
            } .listRowSeparator(.hidden)
                    .headerProminence(.increased)
            Section(header: Text("Registrado")) {
                if verifyRegister(n: 1) {
                    Text("Nenhuma refeição foi registrada.")
                } else {
                    ForEach(mealTypes.indices) { index in
                        let filteredMeals = meals.filter { meal in
                            meal.mealType == mealTypes[index] && meal.registered == 1
                        }
                        
                        if !filteredMeals.isEmpty {
                            DisclosureGroup (isExpanded: self.expansionHandler.isExpanded(.refeicao(mealTypes[index] + "Registered")),
                                             content: {
                                CardScrollView(meals: filteredMeals)
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                Button(action: {
                                    filteredMealsState = filteredMeals
                                    selectedMeal = mealTypes[index]
                                    isSatisfactionSheetPresented.toggle()
                                }) {
                                    HStack(alignment: .center, spacing: 4) {
                                        
                                        Text("Alterar Registro")
                                            .foregroundColor(Color.teal)
                                        
                                    }
                                    .padding(.horizontal, 16)
                                    .frame( height: getHeight() / 20)
                                    .cornerRadius(14)
                                }
                                .padding(.vertical, 8)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                
                                
                            }, label: {
                                Text(mealTypes[index])
                                    .fontWeight(.semibold)
                            }
                            )
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 50, leading: 20, bottom: 20, trailing: 10))
                        }
                    }
                }
            }
                .headerProminence(.increased)
        }
        
        .sheet(isPresented: $isSatisfactionSheetPresented, content: {
            RegisterSatisfactionSheetView(selectedMeal: $selectedMeal, filteredMeals: $filteredMealsState, isAlter: false, selectedDate: selectedDate).presentationDetents([.height(getHeight())])
                            .tint(Color.informationGreen).environmentObject(ModelMeal()).background(Color(red: 0.95, green: 0.95, blue: 0.97))
                    })
            
             
//        DisclosureGroup(
//            isExpanded: self.expansionHandler.isExpanded(.refeicao(mealTypes[index])),
//            content: {
//                CardScrollView(meals: filteredMeals)
//                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
//                Button(action: {
//                    selectedMeal = mealTypes[index]
//                    isSatisfactionSheetPresented.toggle()
//                }) {
//                    HStack(alignment: .center, spacing: 4) {
//                        Image(systemName: "note.text.badge.plus")
//                            .foregroundColor(Color.white)
//                        
//                        Text("Registrar")
//                            .foregroundColor(Color.white)
//                        
//                    }
//                    .padding(.horizontal, 16)
//                    .frame(width: getWidth() / 2.8, height: getHeight() / 20)
//                    .background(Color(red: 0.05, green: 0.51, blue: 0.44))
//                    .cornerRadius(14)
//                }
//                .padding(.vertical, 8)
//                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
//                
//            },
//            label: {
//                Text(mealTypes[index])
//                    .fontWeight(.medium)
//             }
////        )
//            .listRowSeparator(.hidden)
//            .listRowBackground(Color(red: 0.95, green: 0.95, blue: 0.97))
//            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            
                
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

extension DisclosureView {
    
    func verifyRegister(n: Int) -> Bool {
        for index in mealTypes.indices {
            let filteredMeals = meals.filter { meal in
                meal.mealType == mealTypes[index] && meal.registered == n
            }
            if !filteredMeals.isEmpty {
                return(false)
            }
        }
        return(true)
    }
}

    

#Preview {
    DisclosureView(meals: [Meal(id: ObjectIdentifier(Meal.self), name: "Opção A", date: Date(), satisfaction: "", itens: ["Arroz", "Feijão"], weights: ["20","30"], mealType: "Almoço", registered: 0), Meal(id: ObjectIdentifier(Meal.self), name: "Opção B", date: Date(), satisfaction: "", itens: ["Macarrao", "Ervilha"], weights: ["20","30"], mealType: "Almoço", registered: 0)])
}
