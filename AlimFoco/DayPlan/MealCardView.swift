//
//  MealCardView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 14/11/23.
//

import SwiftUI

struct MealCardView: View {
    var body: some View {
        VStack {
            DisclosureGroup("Café da Manhã") {
                CardScrollView()
            }
        }
    }
}

#Preview {
    MealCardView()
}
