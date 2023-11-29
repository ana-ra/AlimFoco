//
//  OnboardingView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI
struct OnboardingView: View {
    @Binding var onboardingCompleted: Bool
    
    var body: some View {
        TabView {
            VStack (alignment: .leading, content: {
                Text("Boas vindas ao")
                    .font(
                        Font.custom("LondrinaSolid-Black", size: 34)
                    )
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                Text("Nutrifica")
                    .font(
                        Font.custom("LondrinaSolid-Black", size: 34)
                    )
                    .foregroundColor(.teal)
                    .multilineTextAlignment(.leading)
                    
                
                HStack {
                    Image(systemName: "chart.bar.doc.horizontal")
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
                }.padding(.top, 54)
                
                
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
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
                
                Button(action: {
                    onboardingCompleted = true
                }) {
                    HStack(alignment: .center, spacing: 4) { 
                        Text("Começar")
                          .font(
                            Font.custom("SF Pro", size: 17)
                              .weight(.semibold)
                          )
                          .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .frame(width: 267, alignment: .center)
                    .foregroundColor(.teal)
                    .cornerRadius(12)
                }
            }).padding(54)
            
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
#Preview {
    OnboardingView(onboardingCompleted: .constant(true))
}
