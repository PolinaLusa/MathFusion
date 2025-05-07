//
//  Item.swift
//  MathFusion
//
//  Created by Полина Лущевская on 14.04.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
