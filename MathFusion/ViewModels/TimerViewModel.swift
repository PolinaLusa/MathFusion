//
//  TimerViewModel.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI
import Combine

class TimerViewModel: ObservableObject {
    @Published var timeRemaining: Float = 5.0
    @Published var progress: Float = 0.0
    
    var timerPublisher: Publishers.Autoconnect<Timer.TimerPublisher> {
        return everySecTimer
    }
    
    private var everySecTimer = Timer.publish(every: 1, tolerance: 1, on: .main, in: .common).autoconnect()
//    private var timer: AnyCancellable?
    var duration: Float = 5.0
    
    func startTimer() {
        everySecTimer = Timer.publish(every: 1, tolerance: 1, on: .main, in: .common).autoconnect()
    }
    
//    func start(duration: Float = 5.0) {
//        self.duration = duration
//        timeRemaining = duration
//        progress = 0.0
//        
//        timer?.cancel()
//        timer = Timer
//            .publish(every: 1, on: .main, in: .common)
//            .autoconnect()
//            .sink { [weak self] _ in
//                guard let self = self else { return }
//                
//                self.timeRemaining -= 1
//                self.progress = 1 - (self.timeRemaining / self.duration)
//                
//                if self.timeRemaining <= 0 {
//                    self.reset()
//                }
//            }
//    }
    
    func stopTimer() {
        everySecTimer.upstream.connect().cancel()
    }
    
//    func stop() {
//        timer?.cancel()
//        timer = nil
//    }
    
    func resetTimer() {
        timeRemaining = 5
        progress = 0
        startTimer()
    }
    
//    func reset() {
//        stop()
//        timeRemaining = duration
//        progress = 0
//    }
}
