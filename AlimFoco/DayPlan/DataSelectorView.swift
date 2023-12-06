//
//  DateSelectorView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 26/10/23.
//

import SwiftUI

struct DateSelectorView: View {
    static var calendar = Calendar.autoupdatingCurrent
    var dates: [Date] = []
    @Binding var selectedDate: Date
    @Namespace var namespace
    
    var body: some View {
        VStack(spacing: getHeight() / 30) {
            HStack {
                Spacer()
                
                if selectedDate.get(.day) == Date().get(.day) {
                    HStack {
                        Text("Today,")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                        
                        Text("\(selectedDate, format: Date.FormatStyle(date: .long, time: .omitted))")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                    }
                } else {
                    Text("\(selectedDate, format: Date.FormatStyle(date: .complete, time: .omitted))")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .font(.system(size: 20))
                }
                
                Spacer()
            }
            
            HStack(spacing: getWidth() / 35) {
                ForEach(self.dates, id: \.self) { date in
                    VStack{
                        if date.get(.day) == Date().get(.day){
                            Circle().frame(width: 10,height: 10)
                                .padding(.top, -10)
                        }
                        else{
                            Circle().frame(width: 10,height: 10)
                                .foregroundColor(.clear)
                                .padding(.top, -10)
                        }
                        DateCircleView(date: date, selected: DateSelectorView.calendar.isDate(date, equalTo: selectedDate, toGranularity: .day), namespace: namespace)
                            .onTapGesture {
                                withAnimation(.bouncy) {
                                    self.selectedDate = date
                                }
                            }
                            
                    }
                }
            }
        }
        .padding()
    }
}

struct DateCircleView: View {
    var date: Date
    var selected: Bool
    var namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: getWidth() / 10)
                .foregroundColor(selected ? Color.teal : .white)
            
            Text("\(dayNumber)")
                .foregroundColor(selected ? .white: .black)
                .font(.title2)
            
        }
    }
    
    var dayNumber: Int {
        return DateSelectorView.calendar.component(.day, from: date)
    }
}

#Preview {
    var dates = [Date]()
    
    for i in -3...3 {
        dates.append(DateSelectorView.calendar.date(byAdding: .day, value: i, to: Date())!)
    }
    
    return DateSelectorView(dates: dates, selectedDate: .constant(Date()))
}
