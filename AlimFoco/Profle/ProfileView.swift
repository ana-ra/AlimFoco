//
//  ProfileView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 29/11/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("CONFIGURAÇÕES")) {
                    Text("Nome: John Doe")
                    Text("Idade: 30 anos")
                    Text("Cidade: Exemploville")
                }
                
                Section(header: Text("Configurações")) {
                    NavigationLink(destination: Text("Detalhes da Conta")) {
                        HStack {
                            Text("Conta")
                            VStack {
                                Text("Conta")
                                Text("Conta")

                            }
                        }
                        
                    }
                    NavigationLink(destination: Text("Preferências")) {
                        Text("Preferências")
                    }
                }
            }.navigationTitle("Carolina Q")
        }
    }
}

#Preview {
    ProfileView()
}
