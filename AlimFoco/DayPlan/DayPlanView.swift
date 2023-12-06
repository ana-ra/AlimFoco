//
//  DayPlanView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 24/10/23.
//

import SwiftUI

struct DayPlanView: View {
    @Binding var isPresentingOnboarding: Bool
    @Binding var hasLoggedIn: Bool
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var modelMeal: ModelMeal
    @State var selectedMeal: String = ""
    @State var selectedDate = Date()
    @State var isNavigatingToNewMealView = false
    @State var isSatisfactionSheetPresented = false
    @State var filteredMealsState: [Meal] = []
    let filteredMeals: [Meal] = []
    let nextMeals: [String] = ["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]
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
                        EmptyState(
                            image: "empty_state",
                            title: "Ops! Está vazio.",
                            description: "Adicione uma nova refeição clicando no + ou em ”Adicionar Refeição\"",
                            buttonText: "Criar nova refeição",
                            action: {
                                isNavigatingToNewMealView.toggle()
                            }
                        )
                        Spacer()
                    }.padding(16)
                } else {
                    List{
                        Section(header: Text("Próximas Refeições")) {
                            DisclosureView(meals: meals)
                            
                        }.headerProminence(.increased)
                        Section(header: Text("Registrado")) {
                            ForEach(mealTypes.indices) { index in
                                let filteredMeals = meals.filter { meal in
                                    meal.mealType == mealTypes[index] && meal.registered == 1
                                }
                                
                                if !filteredMeals.isEmpty {
                                    DisclosureGroup {
                                        CardScrollView(meals: filteredMeals)
                                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                        Button(action: {
                                            filteredMealsState = filteredMeals
                                            selectedMeal = mealTypes[index]
                                            isSatisfactionSheetPresented.toggle()
                                        }) {
                                                
                                            Text("Alterar Registro")
                                                .foregroundColor(Color.informationGreen)
                                                
                                        }
                                        .padding(.vertical, 8)
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                        
                                    } label: {
                                        Text(mealTypes[index])
                                            .fontWeight(.semibold)
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: 50, leading: 20, bottom: 20, trailing: 10))
                                }
                            }
                        }
                        .listRowBackground(Color(red: 0.95, green: 0.95, blue: 0.97))
                            .headerProminence(.increased)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                    }
                    .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                }
            }.background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .onAppear {
                Task {
                    if hasLoggedIn {
                        do {
                            try await modelMeal.populateMeals()
                        } catch {
                            errorView()
                            print(error)
                        }
                    }
                }
            }.onChange(of: isPresentingOnboarding, perform: { value in
                if value {
                    Task {
                        do {
                            try await modelMeal.populateMeals()
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
                        }
                    }
                }
            })
            .toolbar {
                ToolbarItemGroup {
                    NavigationLink(destination: NewMealView(meals: meals, mealTypes: $mealTypes)) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Plano Alimentar")
            .sheet(isPresented: $isSatisfactionSheetPresented, content: {
                RegisterSatisfactionSheetView(selectedMeal: $selectedMeal, filteredMeals: $filteredMealsState).presentationDetents([.height(getHeight())])
                    .tint(Color.informationGreen).environmentObject(ModelMeal()).background(Color(red: 0.95, green: 0.95, blue: 0.97))
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
    func errorView() -> some View {
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
    }
}
                            
//struct DayPlanView_Previews: PreviewProvider {
//    static var previews: some View {
//        DayPlanView(
//            isPresentingOnboarding: .constant(true),
//            hasLoggedIn: .constant(false)
//        ).environmentObject(Model())
//    }
//}
