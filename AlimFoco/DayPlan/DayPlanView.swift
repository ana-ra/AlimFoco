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
    @EnvironmentObject private var modelMealType: ModelMealType
    @State var selectedMeal: String = ""
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
                    List {
                        Section(header: Text("Próximas Refeições")) {
                            ForEach(mealTypes.indices) { index in
                                let filteredMeals = meals.filter { meal in
                                    meal.mealType == mealTypes[index]
                                }
                            
                                if !filteredMeals.isEmpty {
                                    DisclosureGroup {
                                        CardScrollView(meals: filteredMeals)
                                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                         Button(action: {
                                            selectedMeal = mealTypes[index]
                                            isSatisfactionSheetPresented.toggle()
                                        }) {
                                            HStack(alignment: .center, spacing: 4) {
                                                Text("Registrar Refeição")
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
            }.background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .onAppear {
                Task {
                    if hasLoggedIn {
                        do {
                            try await loadMealData()
                            print(modelMeal.Meals)
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
                    
                    NavigationLink(destination: HistoryView()) {
                        Image(systemName: "calendar")
                    }
                }
            }
            .navigationTitle("Plano Alimentar")
            .sheet(isPresented: $isSatisfactionSheetPresented, content: {
                RegisterSatisfactionSheetView(selectedDate: $selectedDate, meal: $selectedMeal).presentationDetents([.height(getHeight() / 3.5)])
                    .tint(Color.informationGreen).environmentObject(ModelMealType())
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
    
    func loadMealData() async throws {
        try await modelMeal.populateMeals()
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
                            
struct DayPlanView_Previews: PreviewProvider {
    static var previews: some View {
        DayPlanView(
            isPresentingOnboarding: .constant(true),
            hasLoggedIn: .constant(false)
        ).environmentObject(Model())
    }
}
