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
    
    private init() {
        setupRealm()
    }
    
    private var realm: Realm {
        return try! Realm()
    }
    
    func saveGameResult(result: GameResult) {
        do {
            try realm.write {
                realm.add(result)
            }
        } catch {
            print("Error saving result: \(error)")
        }
    }
    
    func getAllGameResults() -> [GameResult] {
        Array(realm.objects(GameResult.self))
    }
    
    func getResults(forTopic topic: String, level: String) -> [GameResult] {
        let results = realm.objects(GameResult.self)
            .filter("topic == %@ AND level == %@", topic, level)
        return Array(results)
    }
    
    private func setupRealm() {
        let config = Realm.Configuration(
            schemaVersion: 3,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: GameResult.className()) { oldObject, newObject in
                        newObject?["topic"] = oldObject?["level"] ?? ""
                        newObject?["level"] = oldObject?["difficulty"] ?? ""
                    }
                }
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
}
