//
//  MainView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 23/11/23.
//

import SwiftUI

struct MainView: View {
    @AppStorage("hasOnboardingCompleted") private var hasOnboardingCompleted = false
    @AppStorage("accountName") private var accountName = ""
    @State private var isPresentingOnboarding = false
    
    
    var body: some View {
        TabView{
            DayPlanView(isPresentingOnboarding: $hasOnboardingCompleted)
                .environmentObject(ModelMeal())
                .environmentObject(Model())
                .tabItem {
                    Label("Ínicio", systemImage: "list.bullet.rectangle.portrait")
                }
            ProfileView(accountName: accountName)
                .environmentObject(Model())
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
        }.sheet(
            isPresented: Binding<Bool>(
                get: { !hasOnboardingCompleted },
                set: { _ in }
            ), 
            
            content: {
                OnboardingView(
                    onboardingCompleted: $hasOnboardingCompleted,
                    accountName: $accountName
                ).interactiveDismissDisabled()
            })
        .onAppear {
            isPresentingOnboarding = true
        }
    }
}

#Preview {
    MainView()
}
