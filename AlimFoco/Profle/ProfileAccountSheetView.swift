//
//  ProfileAccountSheetView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI

struct ProfileAccountSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                    Text("Continuar usando o app")
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
            Button {dismiss()} label: {
                Text(secondaryButtonTitle)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
                    .foregroundColor(.errorRed)
                    .padding(.top, 12)
            }
        }).padding(40)
    }
}

#Preview {
    ProfileAccountSheetView(title: "O que você quer?", secondaryButtonTitle: "Não sei")
}
