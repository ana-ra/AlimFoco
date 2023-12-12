//
//  ProfileView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI

var showKcal: Bool = true

struct ProfileView: View {
    @State private var isDeleteAccountSheetViewPresented = false
    let accountName: String
    @State var isKcalOn: Bool = true
    var body: some View {
        VStack {
            NavigationStack {
                List {
                    Section(header: Text("Configurações")) {
//                        NavigationLink(destination: Text("Assinatura")) {
//                            HStack {
//                                Image(systemName: "bag")
//                                    .frame(width: 16, height: 16)
//                                    .foregroundColor(.lightGreen)
//                                    .padding(.trailing, 12)
//                                VStack (alignment: .leading, content: {
//                                    Text("Assinatura")
//                                        .font(.system(size: 16))
//                                    Text("Planos de assinatura do app")
//                                        .font(.system(size: 14))
//                                        .foregroundColor(.gray)
//                                    
//                                })
//                            }
//                            
//                        }
                        NavigationLink(destination: TotalMealsView()) {
                            HStack {
                                Image(systemName: "carrot")
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.lightGreen)
                                    .padding(.trailing, 12)
                                VStack (alignment: .leading, content: {
                                    Text("Refeições")
                                        .font(.system(size: 16))
                                    Text("Meu inventário de refeições")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                })
                            }
                            
                        }
                    }
                    
                    Section(header: Text("Preferências")) {
                        
                            Toggle(isOn: $isKcalOn) {
                                HStack{
                                    Image(systemName: "chart.bar")
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(.salmon)
                                        .padding(.trailing, 12)
                                    Text("Mostrar calorias")
                                        .font(.system(size: 16))
                            }
                            }.tint(.teal)
                    }
                    
                    Section(header: Text("Conta")) {
                        Button(action: {
                            isDeleteAccountSheetViewPresented.toggle()
                        }) {
                            Text("Resetar conta")
                                .font(.system(size: 16))
                                .foregroundColor(.errorRed)
                        }
                    }
                }.navigationTitle(accountName)
                
            }
        }.sheet(isPresented: $isDeleteAccountSheetViewPresented, content: {
            ProfileAccountSheetView( title: "Deseja resetar todos os dados associados ao aplicativo do iCloud?", secondaryButtonTitle: "Resetar conta").presentationDetents([.height(getHeight() / 3.0)])
        })
        .onChange(of: isKcalOn, perform: { value in
            showKcal = isKcalOn
        })
    }
}

#Preview {
   ProfileView(accountName: "Carol")
}
