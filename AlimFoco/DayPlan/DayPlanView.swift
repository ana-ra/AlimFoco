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
    @State var accountStatusMessage: String? = nil
    @State var nextMeals = ["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]
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
                
                if accountStatusMessage != nil {
                    VStack {
                        ErrorState(
                            image: "no_connection",
                            title: "Ops! Algo deu errado. Parece que você não fez login no iCloud.",
                            description: "Faça login no iCloud para usar o app.",
                            buttonText: nil,
                            action: {}
                        )
                    }
                    .padding(16)
                    .background(.white)
                    .cornerRadius(12)
                }
                else if meals.isEmpty {
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
                        Section(header: Text("Próximas refeições")) {
                            if verifyRegister() == 1 {
                                HStack{
                                    Text("Todas as refeições do dia foram registradas")
                                }
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(14)
                            } else {
                                ForEach(nextMeals.indices) { index in
                                    let filteredMeals = meals.filter { meal in
                                        meal.mealType == nextMeals[index]
                                    }
                                    
                                    var day = selectedDate.get(.day)
                                    var month = selectedDate.get(.month)
                                    
                                    let registeredMeals = filteredMeals.filter { meal in
                                        meal.registered == 1 && meal.date.get(.day) == day /*&& meal.date.get(.month) == month*/
                                    }
                                   
                                    if !filteredMeals.isEmpty && registeredMeals.isEmpty {
                                        DisclosureGroup {
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
                                                .background(Color.teal)
                                                .cornerRadius(14)
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
                        }.listRowBackground(Color.clear)
                            .headerProminence(.increased)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                        
                        Section(header: Text("Registrado")) {
                            if verifyRegister() == 0 {
                                Text("Nenhuma refeição foi registrada.")
                            } else {
                                ForEach(mealTypes.indices) { index in
                                    let filteredMeals = meals.filter { meal in
                                        meal.mealType == mealTypes[index] && meal.registered == 1 && selectedDate.get(.month) == meal.date.get(.month) && selectedDate.get(.day) == meal.date.get(.day)
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
                        }
                        .listRowBackground(Color.clear)
                            .headerProminence(.increased)
                            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                    }
                    .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .refreshable {
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
                    }
                }
            }.background(Color(UIColor.systemGroupedBackground))
            .onAppear {
                Task {
                    if hasLoggedIn {
                        do {
                            let status = await modelMeal.login()
                            switch status {
                            case .available:
                                accountStatusMessage = nil
                                try await modelMeal.populateMeals()
                            case .noAccount:
                                accountStatusMessage = "Usuário não está logado no iCloud"
                            case .restricted:
                                accountStatusMessage = "Acesso ao iCloud está restrito"
                            case .couldNotDetermine:
                                accountStatusMessage = "Não foi possível determinar o status da conta"
                            case .unknown:
                                accountStatusMessage = "Status da conta desconhecido"
                            }
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
            .onChange(of: selectedDate, perform: { date in
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
    
    func verifyRegister() -> Int {
        var contador = 0
        var numTypes = 5
        
        for mealType in mealTypes {
            let filteredMeals = meals.filter { meal in
                meal.mealType == mealType
            }
            
            if filteredMeals.isEmpty {
                numTypes -= 1
            }
            
            let day = selectedDate.get(.day)
            let month = selectedDate.get(.month)
            
            let registeredMeals = filteredMeals.filter { meal in
                meal.registered == 1 && meal.date.get(.day) == day
            }
            
            if !registeredMeals.isEmpty {
                contador += 1
            }
        }
        
        if contador == numTypes {
            return 1
        } else if contador == 0 {
            return 0
        } else {
           return -1
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
