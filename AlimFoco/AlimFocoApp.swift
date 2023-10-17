//
//  AlimFocoApp.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 17/10/23.
//

import SwiftUI

@main
struct AlimFocoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
