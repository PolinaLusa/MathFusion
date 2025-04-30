//
//  GameResult.swift
//  MathFusion
//
//  Created by Полина Лущевская on 24.04.25.
//

import Foundation
import RealmSwift

class GameResult: Object, Identifiable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var topic: String = ""
    @Persisted var level: String = ""  
    @Persisted var gameTime: Double = 0.0
    @Persisted var correctAnswers: Int = 0
    @Persisted var incorrectAnswers: Int = 0
    @Persisted var bestScore: Int = 0
    @Persisted var avgTimePerAnswer: Double = 0.0
    @Persisted var bestTimePerAnswer: Double = 0.0
    @Persisted var gameDate: Date = Date()
    
}
