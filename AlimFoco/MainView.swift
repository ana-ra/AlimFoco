//
//  MainView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 23/11/23.
//

import SwiftUI

struct MainView: View {
    @AppStorage("hasOnboardingCompleted") private var hasOnboardingCompleted = false
    
    
    var body: some View {
        
        if !hasOnboardingCompleted {
            OnboardingView(onboardingCompleted: $hasOnboardingCompleted)
        } else {
                    TabView{
            DayPlanView()
                .environmentObject(ModelMeal())
                .environmentObject(Model())
                .tabItem {
                    Label("Registro", systemImage: "list.bullet.rectangle.portrait")
                }
            HistoryView()
                .tabItem {
                    Label("Histórico", systemImage: "calendar")
                }
            TotalMealsView()
                .tabItem {
                    Label("Refeições", systemImage: "fork.knife")
                }
        }
    }
}

#Preview {
    MainView()
}
