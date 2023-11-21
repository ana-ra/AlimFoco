//
//  FIlterView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 21/11/23.
//

import SwiftUI

let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

struct FilterView: View {
    @StateObject var viewModel = foodListViewModel()

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                List {
                    ForEach(alphabet, id: \.self) { letter in
                        let subItems = viewModel.filteredAlimentos.filter({ (alimento) -> Bool in
                            alimento.nome.prefix(1).folding(options: .diacriticInsensitive, locale: .current) == letter
                        })
                        if !subItems.isEmpty {
                            Section(header: Text(letter).id(letter)) {
                                ForEach(subItems, id: \.self) { alimento in
                                    Text("\(alimento.nome)")
                                }
                            }
                            .id(letter)
                        }
                    }
                }
                .onSubmit(of: .search) {
                    print("submitted")
                }
                .overlay(alignment: .trailing) {
                    SectionIndexTitles(proxy: scrollProxy)
                        .padding()
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Buscar alimentos")
            .navigationTitle("Selecionar Alimento")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

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
    }
    
    private func dragObserver(geometry: GeometryProxy, title: String) -> some View {
        if geometry.frame(in: .global).contains(dragLocation) {
        // we need to dispatch to the main queue because we cannot access to the
        // `ScrollViewProxy` instance while the body is rendering
            DispatchQueue.main.async {
                proxy.scrollTo(title, anchor: .center)
            }
        }
        
        return Rectangle().fill(Color.clear)
    }
}

#Preview {
    FilterView()
}
