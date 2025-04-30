//
//  TimerViewModel.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: Float = 0.0
    @Published var progress: Float = 0.0
    @Published var isTimerFinished: Bool = false
    @Published var isRunning: Bool = false
    private var timerSubscription: Cancellable?

    var duration: Float = 0.0
    var onTimerFinish: (() -> Void)?

    func startTimer(duration: Float) {
        self.duration = duration
        self.timeRemaining = duration
        self.progress = 0
        self.isTimerFinished = false
        
        stopTimer() // Останавливаем предыдущий таймер, если был
        
        isRunning = true
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                    self.progress = 1 - (self.timeRemaining / self.duration)
                } else {
                    self.isTimerFinished = true
                    self.stopTimer()
                    self.onTimerFinish?()
                }
            }
    }

    func stopTimer() {
        timerSubscription?.cancel()
        isRunning = false
    }

    var timeMessage: String {
        switch timeRemaining {
        case 0...1:
            return "Time's over!"
        case 1...5:
            return "Time's almost up!"
        case 6...15:
            return "Quick! Quick!"
        case 16...25:
            return "Hurry up!"
        case 26...35:
            return "Don't slow down!"
        case 36...50:
            return "Keep pushing!"
        case 51...70:
            return "You're doing great!"
        case 71...150:
            return "Let's go!"
        default:
            return "Ready?"
        }
    }
}
