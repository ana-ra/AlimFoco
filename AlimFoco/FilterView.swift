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
    @Binding var selection: Alimento?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dismissSearch) private var dismissSearch

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollProxy in
                List(selection: $selection) {
                    ForEach(alphabet, id: \.self) { letter in
                        let subItems = viewModel.filteredAlimentos.filter({ (alimento) -> Bool in
                            alimento.nome.prefix(1).folding(options: .diacriticInsensitive, locale: .current) == letter
                        })
                        if !subItems.isEmpty {
                            Section(header: Text(letter).id(letter)) {
                                ForEach(subItems, id: \.self) { alimento in
                                    Text("\(alimento.nome)")
//                                    Button {
//                                        selection = alimento
//                                        print(selection!.nome)
//                                    } label: {
//                                        Text("\(alimento.nome)")
//                                            .foregroundColor(.primary)
//                                    }
                                }
                            }
                            .id(letter)
                        }
                    }
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

//#Preview {
//    FilterView()
//}
