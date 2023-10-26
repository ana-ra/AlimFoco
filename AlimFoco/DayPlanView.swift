//
//  DayPlanView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 24/10/23.
//

import SwiftUI

struct DayPlanView: View {
    @State var selectedDate = Date()

    //var day:[Date]
    var body: some View {
        VStack {
            DateSelectorView(dates: dates(for: Date()), selectedDate: $selectedDate)
            Spacer()
            
            List {
                Section(header: Text("Refeições")) {
                    DisclosureGroup("Café da Manhã") {
                        VStack(alignment: .leading) {
                            Text("salada")
                            Text("100g").foregroundColor(.secondary)
                        }
                    }
                    
                    DisclosureGroup("Colação") {
                        Text("Frango, Batata, Salada e Feijão")
                    }
                    
                    DisclosureGroup("Almoçar") {
                        Text("Frango, Batata, Salada e Feijão")
                    }
                    
                    DisclosureGroup("Lanche") {
                        Text("Frango, Batata, Salada e Feijão")
                    }
                    
                    DisclosureGroup("Jantar") {
                        Text("Frango, Batata, Salada e Feijão")
                    }
                }
                .headerProminence(.increased)
                .frame(height: getHeight() / 18)
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
        DayPlanView()
    }
}
