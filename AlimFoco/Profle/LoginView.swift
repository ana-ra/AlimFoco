//
//  LoginView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI
import CloudKit

struct LoginView: View {
    
    @EnvironmentObject private var modelMeal: ModelMeal
    
    @Binding var onboardingCompleted: Bool
    @Binding var hasLoggedIn:Bool
    @Binding var accountName: String
    
    @State var accountStatusMessage: String? = nil
    
    var body: some View {
        
        
        VStack {
            Text("Nutrifica")
                .font(
                    Font.custom("LondrinaSolid-Black", size: 42)
                )
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
            
            if(accountStatusMessage == nil) {
                
                Image("LogoTeal")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minWidth: 110, maxWidth: 110)
                
                Button(action: {
                    CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
                        CKContainer.default().fetchUserRecordID { (record, error) in
                            CKContainer.default().discoverUserIdentity(withUserRecordID: record!, completionHandler: { (userID, error) in
                                accountName = (userID?.nameComponents?.givenName)!
                            })
                        }
                    }
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
                            .fill(Color.teal)
                    )
                    .cornerRadius(12)
                }.padding(.top, 28)
                Text("Utilizaremos seu login do iCloud para entrar.")
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
            } else {
                VStack {
                    ErrorState(
                        image: "no_connection",
                        title: "Ops! Algo deu errado. Parece que você não fez login no iCloud.",
                        description: "Faça login no iCloud para continuar.",
                        buttonText: nil,
                        action: {}
                    )
                }
                .padding(16)
                .background(.white)
                .cornerRadius(12)
            }
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
        .onAppear() {
            Task {
                let status = await modelMeal.login()
                switch status {
                case .available:
                    accountStatusMessage = nil
                case .noAccount:
                    accountStatusMessage = "Usuário não está logado no iCloud"
                case .restricted:
                    accountStatusMessage = "Acesso ao iCloud está restrito"
                case .couldNotDetermine:
                    accountStatusMessage = "Não foi possível determinar o status da conta"
                case .unknown:
                    accountStatusMessage = "Status da conta desconhecido"
                }
            }
        }
        
    }
}

//#Preview {
//    LoginView(
//        onboardingCompleted: .constant(true),
//        hasLoggedIn: .constant(false)
//    )
//}
