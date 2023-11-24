//
//  RegisterSatisfactionSheetView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 14/11/23.
//

import SwiftUI

struct RegisterSatisfactionSheetView: View {
    @State private var selectedOption: Int? = nil
    @Environment(\.dismiss) var dismiss
    
    let options = ["Pouco", "Médio", "Muito", "Não realizada"]
    
    var isButtonEnabled: Bool {
        return selectedOption != nil
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancelar")
                }
            }
            Spacer()
            Text("O quanto seguiu a refeição?")
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.bottom, 16)
  
            ForEach(0..<options.count, id: \.self) { index in
                VStack {
                    HStack {
                        Text(options[index])
//                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: self.selectedOption == index ? "checkmark.circle.fill" : "checkmark.circle")
                            .onTapGesture {
                                withAnimation {
                                    self.selectedOption = self.selectedOption == index ? nil : index
                                }
                            }
                            .foregroundColor(self.selectedOption == index ? Color.informationGreen : .secondary)
                    }
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white)
                    )
                }
                .padding(.horizontal, 16)
            }
            
            Button(action: {
                dismiss()
            }) {
                HStack(
                    alignment: .center,
                    spacing: 4
                ) {
                    Text("Registrar")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(isButtonEnabled ? Color.informationGreen : .gray) // Disable button if no checkbox is selected
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(isButtonEnabled ? Color.informationGreen : Color.gray) // Change button color when disabled
                )
                .disabled(!isButtonEnabled)
            }
            .padding(.top, 16)
        }
        .padding(16)
    }
}

// Preview code remains unchanged
#Preview {
    RegisterSatisfactionSheetView()
}
