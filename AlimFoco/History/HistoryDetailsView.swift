//
//  HistoryModalView.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 27/11/23.
//

import SwiftUI

struct HistoryDetailsView: View {
    let refeicoes : [String] = ["Café da manhã", "Almoço", "Lanche da tarde"]
    @State var isSatisfactionSheetPresented: Bool = false
    
    var body: some View {
        List {
            Section {
                ForEach(refeicoes, id: \.self) { refeicao in
                    DisclosureGroup {
                        CardScrollView()
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                    } label: {
                        HStack {
                            Text(refeicao)
                            Spacer()
                            Text("Alto")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.informationGreen)
                        }
                    }
                }
            } header: {
                Text("Refeições registradas")
                    .fontWeight(.semibold)
            }
            .headerProminence(.increased)
            
            Section {
                DisclosureGroup {
                    CardScrollView()
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                    
                    Button(action: {
                       isSatisfactionSheetPresented.toggle()
                   }) {
                       HStack(alignment: .center, spacing: 4) {
                           Text("Nível de satisfação")
                             .foregroundColor(.black)
                           Spacer()
                           Image(systemName: "plus")
                               .foregroundColor(.black)
                           
                       }
                       .padding(.horizontal, 16)
                       .frame(width: getWidth() / 1.2, height: getHeight() / 17)
                       .background(Color.secondary2)
                       .cornerRadius(10)
                   }
                   .padding(.vertical, 8)
                   .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                } label: {
                    Text("Colação")
                }
            } header: {
                Text("Refeições não registradas")
            }
            .headerProminence(.increased)
        }
        .sheet(isPresented: $isSatisfactionSheetPresented, content: {
            RegisterSatisfactionSheetView().presentationDetents([.height(getHeight() / 2.5)])
                .tint(Color.informationGreen)
        })
    }
}

#Preview {
    HistoryDetailsView()
}
