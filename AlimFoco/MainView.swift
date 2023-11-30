//
//  MainView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 23/11/23.
//

import SwiftUI

struct MainView: View {
    @AppStorage("hasOnboardingCompleted") private var hasOnboardingCompleted = false
    @State private var isPresentingOnboarding = false
    
    
    var body: some View {
            TabView{
                DayPlanView()
                    .environmentObject(ModelMeal())
                    .environmentObject(Model())
                    .tabItem {
                        Label("Ínicio", systemImage: "list.bullet.rectangle.portrait")
                    }
                ProfileView()
                    .tabItem {
                        Label("Perfil", systemImage: "person")
                    }
            }.sheet(
                isPresented: Binding<Bool>(
                    get: { !hasOnboardingCompleted },
                    set: { _ in }
                ), 
                
                content: {
                OnboardingView(onboardingCompleted: $hasOnboardingCompleted).interactiveDismissDisabled()
                })
            .onAppear {
                isPresentingOnboarding = true
            }
    }
}

#Preview {
    MainView()
}
