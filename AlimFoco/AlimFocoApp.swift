//
//  AlimFocoApp.swift
//  AlimFoco
//
//  Created by Silvana Rodrigues Alves on 17/10/23.
//

import SwiftUI

@main
struct AlimFocoApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Model())
        }
    }
}
