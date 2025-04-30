//
//  GameResult.swift
//  MathFusion
//
//  Created by Полина Лущевская on 24.04.25.
//

import Foundation
import RealmSwift

// Модель данных для хранения результатов игры
class GameResult: Object, Identifiable {
    
    // Уникальный идентификатор, используется как primary key и для SwiftUI
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    
    // Уровень игры
    @Persisted var level: String = ""
    
    // Сложность (если ты хочешь их различать)
    @Persisted var difficulty: String = ""
    
    // Общее время игры (в секундах)
    @Persisted var gameTime: Double = 0.0
    
    // Количество правильных ответов
    @Persisted var correctAnswers: Int = 0
    
    // Количество неправильных ответов
    @Persisted var incorrectAnswers: Int = 0
    
    // Лучший счёт (если ты его сохраняешь)
    @Persisted var bestScore: Int = 0
    
    // Среднее время на ответ (в секундах)
    @Persisted var avgTimePerAnswer: Double = 0.0
    
    // Дата игры
    @Persisted var gameDate: Date = Date()
    
}
