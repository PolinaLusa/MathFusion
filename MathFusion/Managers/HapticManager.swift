//
//  HapticManager.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import Foundation
import UIKit

func haptic(type: UINotificationFeedbackGenerator.FeedbackType) {
    UINotificationFeedbackGenerator().notificationOccurred(type)
}

func impact(type: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: type).impactOccurred()
}
