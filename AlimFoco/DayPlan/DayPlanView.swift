//
//  DayPlanView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 24/10/23.
//

import SwiftUI

struct DayPlanView: View {
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var modelMeal: ModelMeal
    @State var selectedDate = Date()
    @State var isNavigatingToNewMealView = false
    @State var isSatisfactionSheetPresented = false
    var mealItems: [MealItem] {
        model.Mealitems
    }
    var meals: [Meal] {
        modelMeal.Meals
    }
    @State var mealTypes = ["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .center){
                DateSelectorView(dates: dates(for: Date()), selectedDate: $selectedDate)
                Spacer()
                
                if meals.isEmpty {
                    VStack () {
                        Spacer()
                        ErrorState(
                            image: "empty_state",
                            title: "Ops! Está vazio.",
                            description: "Não há refeições a serem exibidas para este dia.",
                            buttonText: "Criar nova refeição",
                            action: {
                                isNavigatingToNewMealView.toggle()
                            }
                        )
                        Spacer()
                    }
                } else {
                    List {
                        Section(header: Text("Refeições")) {
                            ForEach(mealTypes.indices) { index in
                                let filteredMeals = meals.filter { meal in
                                    meal.mealType == mealTypes[index]
                                }
                            
                                if !filteredMeals.isEmpty {
                                    DisclosureGroup {
                                        CardScrollView(meals: filteredMeals)
                                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                         Button(action: {
                                            isSatisfactionSheetPresented.toggle()
                                        }) {
                                            HStack(alignment: .center, spacing: 4) {
                                                Text("Nível de satisfação")
                                                  .foregroundColor(.black)
                                                Spacer()
                                                Image(systemName: "plus")
                                                    .foregroundColor(.black)
                                                
                                            }
                                            .padding(.horizontal, 16)
                                            .frame(width: getWidth() / 1.2, height: getHeight() / 17)
                                            .background(Color.secondary2)
                                            .cornerRadius(10)
                                        }
                                        .padding(.vertical, 8)
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                    } label: {
                                        Text(mealTypes[index])
                                            .fontWeight(.semibold)
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 50, leading: 20, bottom: 20, trailing: 10))
                                } // Adiciona espaço vertical
                            }
                            
                        }
                        .headerProminence(.increased)
                        
                        Section(header: Text("Registrado")) {
                            
                        }
                        .headerProminence(.increased)
                    }
                }
            }.task {
                do {
                    try await modelMeal.populateMeals()
                    print(modelMeal.Meals)
//                    try await model.populateMealItems()
                } catch {
                    VStack {
                        Spacer()
                        ErrorState(
                            image: "no_connection",
                            title: "Ops! Algo deu errado.",
                            description: "Parece que você está sem conexão.",
                            buttonText: "Tente novamente",
                            action: {}
                        )
                        Spacer()
                    }
                    print(error)
                }
            }
            .toolbar {
                ToolbarItemGroup {
                    NavigationLink(destination: NewMealView(meals: meals, mealTypes: $mealTypes)) {
                        Image(systemName: "plus")
                    }
                    
                    NavigationLink(destination: HistoryView()) {
                        Image(systemName: "calendar")
                    }
                }
            }
            .navigationTitle("Plano Alimentar")
            .sheet(isPresented: $isSatisfactionSheetPresented, content: {
                RegisterSatisfactionSheetView().presentationDetents([.height(getHeight() / 2.5)])
                    .tint(Color.informationGreen)
            })
        }
    }
    
    func dates(for startDate: Date) -> [Date] {
        var dates = [Date]()
        
        for i in -3...3 {
            dates.append(DateSelectorView.calendar.date(byAdding: .day,  value: i, to: startDate)!)
        }
        
        return dates
    }
}
                            
struct DayPlanView_Previews: PreviewProvider {
    static var previews: some View {
        DayPlanView().environmentObject(Model())
    }
}
