//
//  WelcomeView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var onboardingCompleted: Bool
    @Binding var accountName: String
    
    var body: some View {
        VStack (alignment: .leading, content: {
            Text("Boas vindas ao")
                .font(
                    Font.custom("LondrinaSolid-Black", size: 42)
                )
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
            Text("Nutrifica")
                .font(
                    Font.custom("LondrinaSolid-Black", size: 42)
                )
                .foregroundColor(.teal)
                .multilineTextAlignment(.leading)
            
            
            HStack {
                Image(systemName: "chart.bar.doc.horizontal")
                    .resizable()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.teal)
                VStack (alignment: .leading, content: {
                    Text("Gerencie suas refeições")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    
                    Text("Veja os itens das suas refeições diárias e registre a sua fidelidade a elas.")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                })
            }.padding(.top, 34)
            
            
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .resizable()
                    .frame(width: 34, height: 34)
                    .foregroundColor(.teal)
                VStack (alignment: .leading, content: {
                    
                    Text("Feedback de progresso")
                        .font(.system(size: 16))
                        .fontWeight(.bold)
                    
                    Text("Veja seu progresso de adesão de refeições e de alcance de calorias.")
                        .font(.system(size: 12))
                        .fontWeight(.medium)
                    
                })
            }.padding(.top, 28)
            Spacer()
            NavigationLink(destination: LoginView(
                onboardingCompleted: $onboardingCompleted,
                accountName: $accountName
            ), label:  {
                HStack(alignment: .center, spacing: 4) {
                    Text("Começar")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.teal)
                .cornerRadius(12)
            })
            
        }).padding(.horizontal, 64)
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
    WelcomeView(onboardingCompleted: .constant(true), accountName: .constant("Carol Q"))
}
