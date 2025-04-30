//
//  ContentView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 14.04.25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var navVM: NavigationViewModel

    var body: some View {
        Group {
            switch navVM.selectedScreen {
            case .start:
                MainView()
            case .topics:
                TopicView()
            case .levels:
                LevelsView()
            case .game:
                GameView()
            case .statistics:
                StatsView()
            case .rules:
                RulesView()
            case .gameOver:
                GameOverView()
            }
        }
    }
}
