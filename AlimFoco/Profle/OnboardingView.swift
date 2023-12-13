//
//  OnboardingView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI
struct OnboardingView: View {
    @Binding var onboardingCompleted: Bool
    @Binding var hasLoggedIn: Bool
    @Binding var accountName: String
    @State private var selectedTabIndex: Int = 0
    
    var body: some View {
        NavigationView() {
            WelcomeView(
                onboardingCompleted: $onboardingCompleted,
                hasLoggedIn: $hasLoggedIn,
                accountName: $accountName
            )
            LoginView(
                onboardingCompleted: $onboardingCompleted,
                hasLoggedIn: $hasLoggedIn, accountName: $accountName
            )
        }
    }
}

#Preview {
    OnboardingView(
        onboardingCompleted: .constant(true),
        hasLoggedIn: .constant(false),
        accountName: .constant("Carol")
    )
}
