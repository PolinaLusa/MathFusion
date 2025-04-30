//
//  MathFusionApp.swift
//  MathFusion
//
//  Created by Полина Лущевская on 14.04.25.
//

import SwiftUI
import SwiftData
import RealmSwift

@main
struct MathFusionApp: SwiftUI.App {
    init() {
        _ = RealmManager.shared
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @StateObject var navVM = NavigationViewModel()
    @StateObject var scoresVM = ScoresViewModel()
    @StateObject var timerVM = TimerViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navVM)
                .environmentObject(scoresVM)
                .environmentObject(timerVM)
        }
        .modelContainer(sharedModelContainer)
    }
}
