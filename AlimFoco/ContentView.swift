//
//  ContentView.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 17/10/23.
//

import SwiftUI
import CoreData

enum FilterOptions: String, CaseIterable, Identifiable {
    case all
    case completed
    case incomplete
}

extension FilterOptions {
    
    var id: String {
        rawValue
    }
    
    var displayName: String {
        rawValue.capitalized
    }
}

struct ContentView: View {
    @EnvironmentObject private var model: Model
    @State private var MealTitle: String = ""
    @State private var filterOption: FilterOptions = .all
    
    private var filteredMealItems: [MealItem] {
        model.filterMealItems(by: filterOption)
    }
    
    var body: some View {
        VStack {
            TextField("Enter task", text: $MealTitle)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    // add validation TODO
                    let mealItem = MealItem(title: MealTitle, dateAssigned: Date())
                    Task {
                        try await model.addMealItem(mealItem: mealItem)
                    }
                }
            
            // segmented control
            Picker("Select", selection: $filterOption) {
                ForEach(FilterOptions.allCases) { option in
                    Text(option.displayName).tag(option)
                }
            }.pickerStyle(.segmented)
            
            MealListView(MealItems: filteredMealItems)
            
            Spacer()
        }
        .task {
            do {
                try await model.populateMealItems()
            } catch {
                print(error)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Model())
    }
}
