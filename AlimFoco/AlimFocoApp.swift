//
//  AlimFocoApp.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 17/10/23.
//

import SwiftUI

@main
struct AlimFocoApp: App {

    var body: some Scene {
        WindowGroup {
            DayPlanView().environmentObject(Model())
        }
    }
}

extension View {
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    func getHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
}

extension Date {
    func startOfWeek(using calendar: Calendar = Calendar.autoupdatingCurrent) -> Date {
        calendar.dateComponents([.calendar, .yearForWeekOfYear, .weekOfYear], from: self)
            .date!
    }
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
