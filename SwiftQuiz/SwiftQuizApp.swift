//
//  SwiftQuizApp.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 26/12/23.
//

import SwiftUI
import SwiftData


@main
struct SwiftQuizApp: App {
    @StateObject var userSettings = UserSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [User.self, Points.self, Phases.self])
                .environmentObject(userSettings)
        }
    }
}
