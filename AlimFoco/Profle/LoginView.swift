//
//  LoginView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var onboardingCompleted: Bool
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
            
 
            
            TextField("Digite seu nome", text: $accountName)
                           .padding()
                           .cornerRadius(12)
                           .onChange(of: accountName, perform: { newValue in
                               isButtonEnabled = !newValue.isEmpty
                           })
                       
                           .foregroundColor(.black)
                           //.backgroundColor(.cream)
            
            Text("Utilizaremos seu login do iCloud para entrar.")
                .font(.system(size: 16))
                .fontWeight(.medium)
                .padding(.top, 28)
            
            Button(action: {
                onboardingCompleted = true
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
        }
        .padding(.horizontal, 64)
        .padding(.bottom, 50)
        .padding(.top, 100)
        .background(
            Image("OnboardingBackgroundImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        )
    }
}

#Preview {
    LoginView(
        onboardingCompleted: .constant(true),
        accountName: .constant("Carol")
    )
}
