//
//  HistoryVIew.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 23/11/23.
//

import SwiftUI

struct HistoryView: View {
    @State private var selectedDate = Date()
    @State var selectedMonth = ""
    @State var registered: Int = 0
    @State var notRegistered: Int = 0
    @EnvironmentObject private var modelMeal: ModelMeal
    var meals: [Meal] {
        modelMeal.Meals
    }
    @State var naoRealizados = 0
    
    
    var body: some View {
        List {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(getMonths(currentMonth: monthNumToName(num: selectedDate.get(.month))), id: \.self) { month in
                        Button {
                            refreshView(month)
                        } label: {
                            ZStack {
                                Rectangle()
                                    .frame(height: getHeight() / 20 )
                                    .foregroundStyle(selectedMonth == month ? Color.informationGreen : Color.white)
                                    .cornerRadius(40)

                                Text(month)
                                    .padding(20)
                                    .foregroundStyle(selectedMonth == month ? Color.white : Color.black)
                            }
                        }
                    }
                }
            }
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))
            .listRowInsets(EdgeInsets())
            
            Section {
                VStack {                    
                    ZStack {
                        Rectangle()
                            .cornerRadius(15)
                            .foregroundStyle(Color.informationGreen)
                            .opacity(0.2)
                        
                        HStack {
                            Text("Realizadas")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primary4)
                            
                            Spacer()
                            
                            Text("\(getPercentage(registered)) %")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.primary4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    
                    
                    ZStack {
                        Rectangle()
                            .cornerRadius(15)
                            .foregroundStyle(Color.errorRed)
                            .opacity(0.2)
                        
                        HStack {
                            Text("Não realizadas")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.secondary4)
                            
                            Spacer()
                            
                            Text("\(getPercentage(notRegistered)) %")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.secondary4)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
                .padding(20)
                
            } header: {
                Text("Porcentagem de refeições realizadas")
                    .font(.headline)
            }
            .headerProminence(.increased)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
            
            Section {
                Text("Você seguiu \(registered) refeições de um total de \(registered + notRegistered) refeições.")
            }
        }
        .onAppear(perform: {
            for meal in meals {
                if meal.registered == 0 {
                    naoRealizados += 1
                }
            }
            
            selectedMonth = monthNumToName(num: selectedDate.get(.month))
        })
        .task {
            do {
                try await modelMeal.populateMeals()
                print(modelMeal.Meals)
                refreshView(monthNumToName(num: selectedDate.get(.month)))
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
        .navigationTitle("Resumo Mensal")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func monthNumToName(num: Int) -> String {
        let months: [Int: String] = [
            1: "January",
            2: "February",
            3: "March",
            4: "April",
            5: "May",
            6: "June",
            7: "July",
            8: "August",
            9: "September",
            10: "October",
            11: "November",
            12: "December"
        ]
        
        if let date = months[num] {
            return date
        }
        
        return ""
    }
    
    func refreshView(_ month: String) {
        selectedMonth = month
        registered = 0
        notRegistered = 0
        
        let registeredMeals = meals.filter { meal in
            var mealMonth = monthNumToName(num: meal.date.get(.month))
            var mealYear = meal.date.get(.year)
            
            return (selectedMonth == mealMonth && mealYear == selectedDate.get(.year) && meal.registered == 1)
        }
        
        let notRegisteredMeals = meals.filter { meal in
            var mealMonth = monthNumToName(num: meal.date.get(.month))
            var mealYear = meal.date.get(.year)
            
            return (selectedMonth == mealMonth && mealYear == selectedDate.get(.year) && meal.registered == 0)
        }
        
        registered = registeredMeals.count
        notRegistered = notRegisteredMeals.count
    }
    
    func getMonths(currentMonth: String) -> [String] {
        var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        var slicedMonths: [String] = []
        
        for month in months {
            if month == currentMonth {
                slicedMonths.append(month)
                break
            }
            
            slicedMonths.append(month)
        }
        
        return slicedMonths
    }
    
    func getPercentage(_ numerator: Int) -> Int {
        if registered + notRegistered > 0 {
            return Int((numerator / (registered + notRegistered)) * 100)
        }
        
        return 0
        
    }
    
}

//#Preview {
//    HistoryView()
//        .environment()
//}
