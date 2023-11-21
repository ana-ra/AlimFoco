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
        VStack {
            ForEach(alphabet, id: \.self) { letter in
                Text(letter)
                    .background(dragObserver(title: letter))
                    .foregroundColor(.accentColor)
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
        .frame(width: getWidth() / 12, height: getHeight() / 20)
    }
    
    private func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
        // we need to dispatch to the main queue because we cannot access to the
        // `ScrollViewProxy` instance while the body is rendering
            DispatchQueue.main.async {
                proxy.scrollTo(title, anchor: .trailing)
            }
        }
        
        return Rectangle()
            .fill(Color.clear)
    }
}
