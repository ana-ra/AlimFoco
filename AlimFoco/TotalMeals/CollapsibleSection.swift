//
//  CollapsibleSection.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 04/12/23.
//

import SwiftUI

struct CollapsibleSection<C, H>: View where C: View, H: View {
    @Binding var dictionary: [String:Bool]
    var mealType: String
    @State var showingContent: Bool = false
    var content: C
    var header: H
    
    @inlinable
    init(dictionary: Binding<[String:Bool]>, mealType: String, @ViewBuilder content: () -> C, @ViewBuilder header: () -> H) {
        self._dictionary = dictionary
        self.mealType = mealType
        self.content = content()
        self.header = header()
        
        if let aux = self.dictionary[self.mealType] {
            showingContent = aux
        }
    }
    
    var body: some View {
        Section(
            content: {
                if showingContent {
                    content
                }
            },
            header: {
                HStack {
                    header
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.informationGreen)
                        .rotationEffect(showingContent ? .zero : .degrees(-90))
                        .onTapGesture {
                            withAnimation {
                                showingContent.toggle()
                                dictionary[mealType]!.toggle()
                            }
                        }
                }
            }
        )
    }
}
