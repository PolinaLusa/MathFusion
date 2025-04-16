//
//  GameViewModel.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI
import Foundation

enum Difficulties: String, CaseIterable {
    case veryEasy = "Very easy"
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case ultraHard = "Ultra hard"
}

class GameViewModel: ObservableObject {
    var scoresVM: ScoresViewModel
    var timerVM: TimerViewModel
    @Published var selectedTopic: String = ""
    @Published var selectedLevel: String = ""
    @Published var score = 0
    @Published var correctAnswer = 0
    @Published var isAnswered = false
    @Published var isSelected = Int()
    @Published var isLoading = false
    @Published var difficulty: Difficulties = .medium {
        didSet {
            score = 0
            isAnswered = false
            difficultyForTopScore = difficulty
            generateQuestion()
            generateAnswers()
        }
        willSet {
            impact(type: .medium)
        }
    }
    
    var choiceArray: [Int] = []
    var firstNumber = 0
    var secondNumber = 0
    
    private var difficultyNumber: Int
    
    @Published var difficultyForTopScore: Difficulties = .medium {
        willSet {
            impact(type: .soft)
        }
    }

    init(difficulty: Int, timerVM: TimerViewModel, scoresVM: ScoresViewModel) {
        self.difficultyNumber = difficulty
        self.timerVM = timerVM
        self.scoresVM = scoresVM  
    }

    func generateQuestion() {
        firstNumber = Int.random(in: (difficultyNumber / 4)...(difficultyNumber / 2))
        secondNumber = Int.random(in: (difficultyNumber / 4)...(difficultyNumber / 2))
        correctAnswer = firstNumber + secondNumber
    }

    func generateAnswers() {
        func addFourItemsToArray() {
            choiceArray.removeAll()
            for _ in 0..<3 {
                choiceArray.append(Int.random(in: (difficultyNumber / 2)...difficultyNumber))
            }
            choiceArray.append(correctAnswer)
            choiceArray.shuffle()
        }

        func containsDuplicates() -> Bool {
            for i in 0..<choiceArray.count {
                if choiceArray.dropFirst(i + 1).contains(choiceArray[i]) {
                    return true
                }
            }
            return false
        }

        repeat {
            addFourItemsToArray()
        } while containsDuplicates()
    }

    func checkIfAnswerIsCorrect(answer: Int) {
        if answer == correctAnswer {
            score += 1
            haptic(type: .success)
        } else if score > 0 {
            score -= 1
            haptic(type: .error)
        }
        scoresVM.updateTopScore(for: difficulty, score: score)
    }

    func nextQuestion() {
        impact(type: .medium)
        generateQuestion()
        generateAnswers()
        timerVM.resetTimer()
        isSelected = Int()
        isAnswered = false
    }

    func answer(number: Int) {
        checkIfAnswerIsCorrect(answer: number)
        timerVM.stopTimer()
        isAnswered = true
        isSelected = number
    }
}
