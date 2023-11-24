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
                if !MealItems.isEmpty {
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
                            ForEach(meals, id: \.self) { meal in
                                DisclosureGroup {
                                    CardScrollView()
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
                                    Text(meal.name)
                                        .fontWeight(.semibold)
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 50, leading: 20, bottom: 20, trailing: 10)) // Adiciona espaço vertical
                                
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
            .toolbar {
                ToolbarItemGroup {
                    NavigationLink(destination: NewMealView()) {
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
