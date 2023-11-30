//
//  MainView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 23/11/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            DayPlanView()
                .environmentObject(ModelMeal())
                .environmentObject(Model())
                .tabItem {
                    Label("Registro", systemImage: "list.bullet.rectangle.portrait")
                }
            HistoryView()
                .environmentObject(ModelMeal())
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
