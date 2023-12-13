//
//  ProfileAccountSheetView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI

struct ProfileAccountSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var modelMeal: ModelMeal
    @Binding var showPopup: Bool
    
    let title: String
    let secondaryButtonTitle: String
    
    var body: some View {
        VStack(alignment: .center, content: {
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            Button {dismiss()} label: {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Cancelar")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(14)
            .background(Color.teal)
            .cornerRadius(12)
            Button {
                Task {
                    do {
                        for item in modelMeal.Meals {
                            try await modelMeal.deleteMeal(MealToBeDeleted: item)
                        }
                    } catch {
                        print(error)
                    }
                }
                
                withAnimation {
                    showPopup = true
                    dismiss()
                }
            } label: {
                Text(secondaryButtonTitle)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.errorRed)
                    .padding(.top, 12)
            }
        }).padding(40)
    }
}

//#Preview {
//    ProfileAccountSheetView(title: "O que você quer?", secondaryButtonTitle: "Não sei")
//}
