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
    @State private var alreadyLogged = false
    
    var body: some View {
        TabView{
            DayPlanView(isPresentingOnboarding: $hasOnboardingCompleted,
                        hasLoggedIn: $alreadyLogged)
                .tabItem {
                    Label("Plano", systemImage: "fork.knife")
                }
            HistoryView()
                .tabItem {
                    Label("Resumo", systemImage: "note.text")
                }
            ProfileView(accountName: accountName)
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
        }
        .sheet(
            isPresented: Binding<Bool>(
                get: { 
                    !hasOnboardingCompleted },
                set: { _ in }
            ), 
            
            content: {
                OnboardingView(
                    onboardingCompleted: $hasOnboardingCompleted,
                    hasLoggedIn: $alreadyLogged,
                    accountName: $accountName
                ).interactiveDismissDisabled()
            })
        .onAppear {
            alreadyLogged = hasOnboardingCompleted
            isPresentingOnboarding = true
            UITabBar.appearance().backgroundColor = UIColor.white
        }
    }
}

#Preview {
    MainView()
}
