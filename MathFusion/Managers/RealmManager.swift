//
//  RealmManager.swift
//  MathFusion
//
//  Created by Полина Лущевская on 24.04.25.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    // Получаем доступ к базе данных
    private var realm: Realm {
        return try! Realm()
    }
    
    // Сохранение результата игры в базу данных
    func saveGameResult(result: GameResult) {
        do {
            try realm.write {
                realm.add(result)
            }
        } catch {
            print("Error saving result: \(error)")
        }
    }
    
    // Получение всех результатов игры
    func getAllGameResults() -> [GameResult] {
        let results = realm.objects(GameResult.self)
        return Array(results)
    }
    
    // Получение результатов игры по уровню и сложности
    func getResults(forLevel level: String, difficulty: String) -> [GameResult] {
        let results = realm.objects(GameResult.self).filter("level == %@ AND difficulty == %@", level, difficulty)
        return Array(results)
    }
}
