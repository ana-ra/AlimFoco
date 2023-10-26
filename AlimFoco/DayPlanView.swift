//
//  DayPlanView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 24/10/23.
//

import SwiftUI

struct DayPlanView: View {
    @State var monthString: String = "Not Set"

    let calendar = Calendar.current
     
    //var day:[Date]
    var body: some View {
        let dates = getWeek()
        
        VStack {
            // MARK: Change Date() to some identifier of selected date.
            HStack {
                Text("\(getDayNumber(date: Date()))")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("of")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(getMonth(date: Date()))
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(dates, id: \.self) { day in
                        VStack {
    //                            Text(getDayShort(date: day))
    //                                .font(.title)
                            let dayNumber = getDayNumber(date: day)
                            
                            if dayNumber == getDayNumber(date: Date()) {
                                ZStack {
                                    Circle()
                                        .fill(.blue)
                                        .scaleEffect(1)
                                    
                                    Text("\(getDayNumber(date: day))")
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                }
                            } else {
                                Text("\(getDayNumber(date: day))")
                                    .font(.title3)
                            }
                        }
                        .frame(width: getWidth() / 8, height: getHeight() / 14)
                        .padding(.horizontal, -3)
                   }
                }
                .frame(width: getWidth())
            }
//               .padding(<#T##insets: EdgeInsets##EdgeInsets#>)
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
        .padding(.vertical, getHeight() / 20)
        .background(Color(.systemGroupedBackground))
    }
    
    func getMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }

    func getDayShort(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter.string(from: date)
    }
    
    func getDayNumber(date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date)
        return components.day ?? 0
    }

    func getWeek() -> [Date] {
        let currentDate = Date()

        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: currentDate)
        
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        
        let daysMonth = (range.lowerBound ..< range.upperBound / 4)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: currentDate) }
        
        return daysMonth
    }
}

struct DayPlanView_Previews: PreviewProvider {
    static var previews: some View {
        DayPlanView()
    }
}
