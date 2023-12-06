//
//  RegisterSatisfactionSheetView.swift
//  AlimFoco
//
//  Created by Carol Quiterio on 14/11/23.
//

import SwiftUI

struct RegisterSatisfactionSheetView: View {
    @Binding var selectedMeal: String
    @Binding var filteredMeals: [Meal]
    @State private var selectedOption: Int? = nil
    @State private var selectedMealOption: Int? = nil
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: ModelMeal
    
    let options = ["Seguiu", "Não Seguiu"]
    
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
            Text("Você seguiu a sua refeição?")
                .frame(maxWidth: .infinity, alignment: .leading)
                .fontWeight(.semibold)
                .foregroundColor(.black)
                .padding(.bottom, 8)
            
            List{
                ForEach(0..<options.count, id: \.self) { index in
                    VStack {
                        HStack {
                            Text(options[index])
                            //                            .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: self.selectedOption == index ? "checkmark.circle.fill" : "checkmark.circle")
                                .resizable()
                                .frame(width: 22.0, height: 22.0)
                                .onTapGesture {
                                    withAnimation {
                                        self.selectedOption = self.selectedOption == index ? nil : index
                                    }
                                }
                                .foregroundColor(self.selectedOption == index ? Color.informationGreen : .secondary)
                        }
                        .padding(.vertical, 8)
                    }
                    .padding(.horizontal, 8)
                    .frame(height: getHeight()/32)
                }
            }.frame(height: getHeight()/6)
            
            if (selectedOption == 0){
                Text("Qual dessas opções você comeu?")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.bottom, 8)
                
                List{
                    ForEach(0..<filteredMeals.count, id: \.self) { index in
                        VStack {
                            HStack {
                                Text("\(filteredMeals[index].name)")
                                //                            .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: self.selectedMealOption == index ? "checkmark.circle.fill" : "checkmark.circle")
                                    .resizable()
                                    .frame(width: 22.0, height: 22.0)
                                    .onTapGesture {
                                        withAnimation {
                                            filteredMeals[index].registered = 1
                                            self.selectedMealOption = self.selectedMealOption == index ? nil : index
                                        }
                                    }
                                    .foregroundColor(self.selectedMealOption == index ? Color.informationGreen : .secondary)
                            }
                            .padding(.vertical, 8)
                        }
                        .padding(.horizontal, 8)
                        .frame(height: getHeight()/32, alignment: .center)
                    }
                }
            }
            Spacer()
            Button(action: {
                let editedMeal = filteredMeals[selectedMealOption!]
                
                Task {
                    try await model.updateMeal(editedMeal: editedMeal)
                }
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
            }
            .disabled(!isButtonEnabled)
            .padding(.top, 16)
            Spacer()
        }
        .padding(16)
    }
}

//// Preview code remains unchanged
//#Preview {
//    RegisterSatisfactionSheetView()
//}
