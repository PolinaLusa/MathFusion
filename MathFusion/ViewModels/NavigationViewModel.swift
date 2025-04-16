//
//  NavigationViewModel.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

enum ShowedScreen {
    case start, topics, levels, game, statistics, settings
}

class NavigationViewModel: ObservableObject {
    @Published var selectedScreen: ShowedScreen = .start {
        willSet { impact(type: .medium) }
    }
}
