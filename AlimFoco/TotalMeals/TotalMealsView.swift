//
//  TotalMealsView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 23/11/23.
//

import SwiftUI

struct TotalMealsView: View {
    @EnvironmentObject var mealModel: ModelMeal
    @State var showingSection: [String: Bool] = ["Café da manhã": false, "Colação": false, "Almoço": false, "Lanche da Tarde": false, "Jantar": false]
    var meals: [Meal] {
        mealModel.Meals
    }
    @State var showingSelectedMealType: Bool = false
    @State var mealTypes = ["Café da manhã", "Colação", "Almoço", "Lanche da Tarde", "Jantar"]
    @State var isEditing = false
    @State private var editMode = EditMode.inactive
    
    var body: some View {
        NavigationStack {
            if meals.isEmpty {
                VStack () {
                    EmptyState(
                        image: "empty_state",
                        title: "Ops! Está vazio.",
                        description: "Adicione uma nova refeição clicando no + ou em ”Adicionar Refeição\"",
                        buttonText: "Criar nova refeição",
                        action: {
    //                        isNavigatingToNewMealView.toggle()
                        }
                    )
                    Spacer()
                }
                .padding(16)
            } else {
                List {
                    ForEach(mealTypes, id:\.self) { mealType in
                        let filteredMeals = meals.filter {
                            $0.mealType == mealType
                        }
                        
                        if !filteredMeals.isEmpty {
                            CollapsibleSection(dictionary: $showingSection, mealType: mealType, content: {
                                ForEach(filteredMeals, id: \.self) { meal in
                                    NavigationLink(destination: EditMealView(meals: meals, mealTypes: mealTypes, meal: meal)) {

                                        if meal.name != "" {
                                            Text(meal.name)
                                        } else {
                                            Text("Sem título")
                                        }
                                    }
                                }
                                .onDelete { offsets in
                                    for index in offsets {
                                        deleteNavigationLinks(filteredMeals[index])
                                    }
                                }
                            }, header: {
                                Text(mealType)
                                    .fontWeight(.semibold)
                                    .font(.headline)
                                    .foregroundStyle(.black)
                            })
                        }
                    }
                }
                .navigationTitle("Suas Refeições")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            NavigationLink(destination: NewMealView(meals: meals, mealTypes: $mealTypes)) {
                                Text("Adicionar Refeição")
                            }
                            
                            Button {
                                withAnimation(.spring()) {
                                    isEditing.toggle()
                                    editMode = isEditing ? .active : .inactive
                                }
                            } label: {
                                let buttonText = isEditing ? "OK" : "Editar"
                                Text(buttonText)
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundStyle(Color.informationGreen)
                        }
                    }
                }
                .environment(\.editMode, $editMode)
            }
        }

        .onAppear(perform: {
            Task {
                do {
                    try await mealModel.populateMeals()
                } catch {
                    VStack {
                        Spacer()
                        ErrorState(
                            image: "no_connection",
                            title: "Ops! Algo deu errado.",
                            description: "Parece que você está sem conexão.",
                            buttonText: "Tente novamente",
                            action: {}
                        )
                        Spacer()
                    }
                }
            }
        })
    }
    
    func deleteNavigationLinks(_ selectedMeal: Meal) {
        withAnimation {
            Task {
                do {
                    try await mealModel.deleteMeal(MealToBeDeleted: selectedMeal)
                    try await mealModel.populateMeals()
                } catch {
                    print(error)
                }
            }
        }
        print("hello")
    }
}

#Preview {
    TotalMealsView()
        .environmentObject(ModelMeal())
}
