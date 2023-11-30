//
//  OnboardingView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI
struct OnboardingView: View {
    @Binding var onboardingCompleted: Bool
    @State private var selectedTabIndex: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            WelcomeView(onboardingCompleted: $onboardingCompleted, selectedTabIndex: $selectedTabIndex)
            LoginView(onboardingCompleted: $onboardingCompleted)
        }.tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
    }
}

#Preview {
    OnboardingView(onboardingCompleted: .constant(true))
}
