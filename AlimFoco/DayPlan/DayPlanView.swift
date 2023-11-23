//
//  DayPlanView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 24/10/23.
//

import SwiftUI

struct DayPlanView: View {
    @EnvironmentObject private var model: Model
    @State var selectedDate = Date()
    @State var isNavigatingToNewMealView = false
    @State var isSatisfactionSheetPresented = false
    var MealItems: [MealItem] {
        model.Mealitems
    }
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .center){
                DateSelectorView(dates: dates(for: Date()), selectedDate: $selectedDate)
                Spacer()
                if MealItems.isEmpty {
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
                            ForEach(MealItems, id: \.recordId) {mealItem in
                                DisclosureGroup(mealItem.name) {
                                    CardScrollView()
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
                                        .padding(.vertical, 0)
                                        .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .leading)
                                        .background(Color(red: 0.84, green: 0.54, blue: 0.08).opacity(0.4))
                                        .cornerRadius(10)
                                    }
                                }
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
                    try await model.populateMealItems()
                } catch {
                    VStack () {
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
            .background(Color(.systemGroupedBackground))
            .navigationDestination(
                isPresented: $isNavigatingToNewMealView,
                destination: {
                    NewMealView()
                }
            )
            .sheet(isPresented: $isSatisfactionSheetPresented, content: {
                RegisterSatisfactionSheetView().presentationDetents([.height(351)])
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
