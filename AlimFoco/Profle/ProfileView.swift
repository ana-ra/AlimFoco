//
//  ProfileView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI

struct ProfileView: View {
    @State private var isDeleteAccountSheetViewPresented = false
    @State private var isLogoutViewSheetViewPresented = false
    @State var showCalorias = true
    let accountName: String
    
    var body: some View {
        VStack {
            NavigationStack {
                List {
                    Section(header: Text("Configurações")) {
                        NavigationLink(destination: Text("Assinatura")) {
                            HStack {
                                Image(systemName: "bag")
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.lightGreen)
                                    .padding(.trailing, 12)
                                VStack (alignment: .leading, content: {
                                    Text("Assinatura")
                                        .font(.system(size: 16))
                                    Text("Planos de assinatura do app")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                })
                            }
                            
                        }
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
                        
                            Toggle(isOn: $showCalorias) {
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
                            isLogoutViewSheetViewPresented.toggle()
                        }) {
                            Text("Sair")
                                .font(.system(size: 16))
                                .foregroundColor(.errorRed)
                        }
                        Button(action: {
                            isDeleteAccountSheetViewPresented.toggle()
                        }) {
                            Text("Deletar conta")
                                .font(.system(size: 16))
                                .foregroundColor(.errorRed)
                        }
                    }
                }.navigationTitle(accountName)
                
            }
        }.sheet(isPresented: $isDeleteAccountSheetViewPresented, content: {
            ProfileAccountSheetView(title: "Tem certeza de que deseja deletar sua conta?", secondaryButtonTitle: "Deletar conta").presentationDetents([.height(getHeight() / 3.5)])
            
        })
        .sheet(isPresented: $isLogoutViewSheetViewPresented, content: {
            ProfileAccountSheetView(title: "Tem certeza de que deseja sair do app?", secondaryButtonTitle: "Sair").presentationDetents([.height(getHeight() / 3.5)])
        })
    }
}

#Preview {
   ProfileView(accountName: "Carol")
}
