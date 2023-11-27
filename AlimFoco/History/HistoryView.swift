//
//  HistoryVIew.swift
//  AlimFoco
//
//  Created by Gustavo Sacramento on 23/11/23.
//

import SwiftUI

struct HistoryView: View {
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationStack {
            List {
                DatePicker("Select date", selection: $selectedDate, in: ...Date(),displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .padding(.bottom, 24)
                
                Section(selectedDate.formatted(date: .complete, time: .omitted)){
                    NavigationLink{
                        HistoryDetailsView()
                            .navigationTitle(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    } label: {
                        VStack(alignment:.leading){
                            Text("Registros")
                                .padding(.bottom, 8)
                        }
                    }
                    .font(.headline)
                    .listRowSeparator(.hidden)
                    
                    ForEach(1..<5){ i in
                        Text("Item \(i)")
                        // Fazer a lógica de trazer as refeições
                    }
                }
            }
        }
    }
}

#Preview {
    HistoryView()
}
