//
//  LoginView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var onboardingCompleted: Bool
    @Binding var hasLoggedIn:Bool
    @Binding var accountName: String
    
    @State var isButtonEnabled: Bool = false
     
    var body: some View {
        
        
        VStack {
            Text("Nutrifica")
                .font(
                    Font.custom("LondrinaSolid-Black", size: 42)
                )
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            Image("LogoTeal")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minWidth: 110, maxWidth: 110)
            
            Text("Como devemos te chamar?")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .padding(.top, 28)
                .multilineTextAlignment(.trailing)
            
            TextField("Digite seu nome", text: $accountName)
                .padding()
                .onChange(of: accountName, perform: { newValue in
                    isButtonEnabled = !newValue.isEmpty
                })
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.clear, lineWidth: 2)
                )
            
            Button(action: {
                onboardingCompleted = true
                hasLoggedIn = true
            }) {
                HStack(alignment: .center, spacing: 4) {
                    Image(systemName: "apple.logo")
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                    
                    Text("Continuar com a Apple")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isButtonEnabled ? Color.black : Color.gray)
                )
                .cornerRadius(12)
            }.padding(.top, 28)
            .disabled(!isButtonEnabled)
            Text("Utilizaremos seu login do iCloud para entrar.")
                .font(.system(size: 12))
                .fontWeight(.medium)
                .foregroundColor(.gray)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 64)
        .padding(.bottom, 50)
        .padding(.top, 50)
        .background(
            Image("OnboardingBackgroundImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .ignoresSafeArea()
        )
        
    }
}

#Preview {
    LoginView(
        onboardingCompleted: .constant(true),
        hasLoggedIn: .constant(false),
        accountName: .constant("Carol")
    )
}
