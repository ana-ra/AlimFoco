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
    var MealItems: [MealItem] {
        model.Mealitems
    }
    @State var meals = [
        Meal(name: "Café da Manhã", items: [Item(name: "Salada", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meal(name: "Colação", items: []),
        Meal(name: "Almoço", items: [Item(name: "asd", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meal(name: "Lanche da Tarde", items: [Item(name: "ffff", weight: 100), Item(name: "Peito de Frango", weight: 150)]),
        Meal(name: "Jantar", items: [Item(name: "Curs", weight: 100), Item(name: "Peito de Frango", weight: 150)])
      ]
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .center){
                DateSelectorView(dates: dates(for: Date()), selectedDate: $selectedDate)
                Spacer()
                
                // Change this to show empty state
                if false {
                    VStack () {
                        Spacer()
                        ErrorState(
                            image: "",
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
                            ForEach(meals, id: \.self) {meal in
                                DisclosureGroup(meal.name) {
                                    CardScrollView()
                                }
                            }
                            

//                            DisclosureGroup("Colação") {
//                                ForEach(MealItems, id: \.recordId){ mealItem in
//                                    Text(mealItem.title)
//                                }.onDelete { indexSet in
//                                    guard let index = indexSet.map({ $0 }).last else {
//                                        return
//                                    }
//                                    let MealItem = model.Mealitems[index]
//                                    Task {
//                                        do {
//                                            try await model.deleteItem(MealItemToBeDeleted: MealItem)
//                                        } catch {
//                                            print(error)
//                                        }
//                                    }
//                                }
//                            }
//

                        }
                        .headerProminence(.increased)
//                            .frame(height: getHeight() / 5)
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
                            image: "",
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
                            
class Meal: ObservableObject, Identifiable, Hashable {
    static func == (lhs: Meal, rhs: Meal) -> Bool {
        lhs.id == rhs.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String {
        name
    }
    
    let name: String
    @Published var items: [Item]
    
    init(name: String, items: [Item]) {
        self.name = name
        self.items = items
    }
}
                            
struct Item: Identifiable {
    let id = UUID()
    var name: String
    let weight: Int
      
    init(name: String, weight: Int) {
        self.name = name
        self.weight = weight
    }
}

struct DayPlanView_Previews: PreviewProvider {
    static var previews: some View {
        DayPlanView().environmentObject(Model())
    }
}
