//
//  ScoresViewModel.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

class ScoresViewModel: ObservableObject {
    @AppStorage("highScore") var topScore = Data()
    @Published var allTopScores: [String: [String: Int]] = [:] {
        didSet {
            saveScores()
        }
    }

    init() {
        loadScores()
    }
    
    func updateTopScore(for topic: String, difficulty: Difficulties, score: Int) {
        if score > currentTopScore(for: topic, difficulty: difficulty) {
            if allTopScores[topic] == nil {
                allTopScores[topic] = [:]
            }
            allTopScores[topic]?[difficulty.rawValue] = score
        }
    }

    func currentTopScore(for topic: String, difficulty: Difficulties) -> Int {
        return allTopScores[topic]?[difficulty.rawValue] ?? 0
    }
    
    private func loadScores() {
        if let saved = try? JSONDecoder().decode([String: [String: Int]].self, from: topScore) {
            allTopScores = saved
        } else {
            let topics = ["Addition", "Subtraction", "Multiplication", "Division", "Mixed operations"]
            topics.forEach { topic in
                allTopScores[topic] = [:]
                Difficulties.allCases.forEach { difficulty in
                    allTopScores[topic]?[difficulty.rawValue] = 0
                }
            }
        }
    }
    
    private func saveScores() {
        if let data = try? JSONEncoder().encode(allTopScores) {
            topScore = data
        }
    }
}
