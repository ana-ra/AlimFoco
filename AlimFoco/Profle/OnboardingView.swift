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
                Button(action: {
                    onboardingCompleted = true
                }) {
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
                }
                
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
        .background(
            Image("OnboardingBackgroundImage.png")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipped()
        )
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}
#Preview {
    OnboardingView(onboardingCompleted: .constant(true))
}
