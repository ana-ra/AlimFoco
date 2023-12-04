//
//  SectionIndexTitle.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 21/11/23.
//

import SwiftUI

struct SectionIndexTitles: View {
    let proxy: ScrollViewProxy
    @GestureState private var dragLocation: CGPoint = .zero
    
    var body: some View {
        VStack(spacing: -5) {
            ForEach(alphabet, id: \.self) { letter in
                Text(letter)
                    .background(dragObserver(title: letter))
                    .foregroundColor(.accentColor)
                    .scaleEffect(0.5)
                    .fontWeight(.bold)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($dragLocation) { value, state, _ in
                    state = value.location
                }
        )
    }
    
    func dragObserver(title: String) -> some View {
        GeometryReader { geometry in
            dragObserver(geometry: geometry, title: title)
        }
        .frame(width: getWidth() / 12, height: getHeight() / 25)
    }
    
    private func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
            DispatchQueue.main.async {
                proxy.scrollTo(title, anchor: .trailing)
            }
        }
        
        return Rectangle()
            .fill(Color.black)
            .opacity(0.001)
    }
}
