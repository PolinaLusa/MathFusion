//
//  ScoresViewModel.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

class ScoresViewModel: ObservableObject {
    @AppStorage("highScore") var topScore = Data()
    @Published var allTopScores: [String: Int] = [:] {
        didSet {
            if let data = try? JSONEncoder().encode(allTopScores) {
                topScore = data
            }
        }
    }

    func updateTopScore(for difficulty: Difficulties, score: Int) {
        if score > (allTopScores[difficulty.rawValue] ?? 0) {
            allTopScores[difficulty.rawValue] = score
        }
    }

    func currentTopScore(for difficulty: Difficulties) -> Int {
        return allTopScores[difficulty.rawValue] ?? 0
    }
    
//    var currentTopScore: Int {
//        for (key, value) in allTopScores {
//            if difficulty.rawValue == key {
//                return value
//            }
//        }
//        return 0
//    }

    func loadScores() {
        if let saved = try? JSONDecoder().decode([String: Int].self, from: topScore) {
            allTopScores = saved
        }
    }
}
