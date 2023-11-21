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
    var MealItems: [MealItem] {        
        model.Mealitems
    }

    var body: some View {
        VStack (alignment: .leading){
            DateSelectorView(dates: dates(for: Date()), selectedDate: $selectedDate)
            
            Spacer()
            
            List{
                Section(header: Text("Refeições")) {
                    DisclosureGroup("Café da Manhã") {
                        CardScrollView()
                        VStack(alignment: .leading) {
                            ForEach(MealItems, id: \.recordId){ mealItem in

                            }.onDelete { indexSet in
                                guard let index = indexSet.map({ $0 }).last else {
                                return
                                }
                                let MealItem = model.Mealitems[index]
                                Task {
                                    do {
                                        try await model.deleteItem(MealItemToBeDeleted: MealItem)
                                    } catch {
                                        print(error)
                                    }
                                }
                            }
                        }
                    }
                    
                    DisclosureGroup("Colação") {
                        ForEach(MealItems, id: \.recordId){ mealItem in
                            Text(mealItem.title)
                        }.onDelete { indexSet in
                            guard let index = indexSet.map({ $0 }).last else {
                            return
                            }
                            let MealItem = model.Mealitems[index]
                            Task {
                                do {
                                    try await model.deleteItem(MealItemToBeDeleted: MealItem)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                    
                    DisclosureGroup("Almoçar") {
                        ForEach(MealItems, id: \.recordId){ mealItem in
                            Text(mealItem.title)
                        }.onDelete { indexSet in
                            guard let index = indexSet.map({ $0 }).last else {
                            return
                            }
                            let MealItem = model.Mealitems[index]
                            Task {
                                do {
                                    try await model.deleteItem(MealItemToBeDeleted: MealItem)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                    
                    DisclosureGroup("Lanche") {
                        ForEach(MealItems, id: \.recordId){ mealItem in
                            Text(mealItem.title)
                        }.onDelete { indexSet in
                            guard let index = indexSet.map({ $0 }).last else {
                            return
                            }
                            let MealItem = model.Mealitems[index]
                            Task {
                                do {
                                    try await model.deleteItem(MealItemToBeDeleted: MealItem)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                    
                    DisclosureGroup("Jantar") {
                        ForEach(MealItems, id: \.recordId){ mealItem in
                            Text(mealItem.title)
                        }.onDelete { indexSet in
                            guard let index = indexSet.map({ $0 }).last else {
                            return
                            }
                            let MealItem = model.Mealitems[index]
                            Task {
                                do {
                                    try await model.deleteItem(MealItemToBeDeleted: MealItem)
                                } catch {
                                    print(error)
                                }
                            }
                        }
                    }
                }.headerProminence(.increased)
                    .frame(height: getHeight() / 10)
            }
            
        }.task {
            do {
                try await model.populateMealItems()
            } catch {
                print(error)
            }
        }
        .background(Color(.systemGroupedBackground))
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



//}
