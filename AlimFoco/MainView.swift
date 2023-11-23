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
            DayPlanView().environmentObject(Model())
                .tabItem {
                    Label("Registro", systemImage: "list.bullet.rectangle.portrait")
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
