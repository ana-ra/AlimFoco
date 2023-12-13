//
//  PerfilPoUpSwiftUIView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 13/12/23.
//

import SwiftUI

struct PerfilPoUpSwiftUIView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(systemName: "checkmark.circle")
              .font(Font.custom("SF Pro", size: 36))
              .multilineTextAlignment(.center)
              .foregroundColor(Color.successGreen)
              .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Todos os dados foram deletados")
                .fontWeight(.semibold)
        }
        .frame(width: getWidth() / 1.4, height: getHeight() / 7)
        .background(Color(red: 0.7, green: 0.7, blue: 0.7).opacity(0.5))
        .cornerRadius(14)
    }
}

#Preview {
    PerfilPoUpSwiftUIView()
}

