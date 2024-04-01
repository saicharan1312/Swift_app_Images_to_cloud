//
//  The_ultimate_photoApp.swift
//  The_ultimate_photo
//
//  Created by Sai Charan  on 1/5/24.
//

import SwiftUI
import Firebase

@main
struct The_ultimate_photoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}
