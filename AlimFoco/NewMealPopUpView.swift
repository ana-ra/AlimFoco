//
//  NewMealPopUpView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 22/11/23.
//

import SwiftUI

struct NewMealPopUpView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(systemName: "checkmark.circle")
              .font(Font.custom("SF Pro", size: 36))
              .multilineTextAlignment(.center)
              .foregroundColor(Color(red: 0.41, green: 0.5, blue: 0.12))
              .frame(maxWidth: .infinity, alignment: .center)
            
            Text("Meal added")
                .fontWeight(.semibold)
        }
        .frame(width: getWidth() / 1.4, height: getHeight() / 7)
        .background(Color(red: 0.7, green: 0.7, blue: 0.7).opacity(0.5))
        .cornerRadius(14)
    }
}

#Preview {
    NewMealPopUpView()
}
