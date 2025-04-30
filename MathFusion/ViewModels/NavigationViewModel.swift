//
//  NavigationViewModel.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

enum ShowedScreen {
    case start, topics, levels, game, statistics, rules, gameOver
}

enum Difficulties: String, CaseIterable {
    case veryEasy = "Very easy"
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case veryHard = "Very hard"
    case extraHard = "Extra hard"
}

class NavigationViewModel: ObservableObject {
    @Published var selectedScreen: ShowedScreen = .start
    @Published var selectedTopic: String = ""
    @Published var selectedLevel: String = "" {
        didSet {
            if let newDifficulty = Difficulties(rawValue: selectedLevel) {
                difficulty = newDifficulty
            }
        }
    }
    @Published var firstNumber: Int = 0
    @Published var secondNumber: Int = 0
    @Published var correctAnswer: Int = 0
    @Published var currentOperation: String = ""
    @Published var choiceArray: [Int] = []
    @Published var isAnswered = false
    @Published var score = 0
    @Published var isGameOver = false
    @Published var timeIsUp = false
    @Published var isSelected: Int = 0
    @Published var isGameInitialized: Bool = false
    @Published var difficulty: Difficulties = .veryEasy
    
    @Published var correctAnswers: Int = 0
    @Published var incorrectAnswers: Int = 0
    @Published var totalQuestions: Int = 0

    var scoresVM = ScoresViewModel()

    func generateQuestion() {
        let finalTopic: String
        if selectedTopic == "Mixed operations" {
            finalTopic = ["Addition", "Subtraction", "Multiplication", "Division"].randomElement()!
        } else {
            finalTopic = selectedTopic
        }

        var addSubRange: ClosedRange<Int>
        var mulDivRange: ClosedRange<Int>

        switch selectedLevel.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
        case "very easy":
            addSubRange = 1...20
            mulDivRange = 1...10
        case "easy":
            addSubRange = 20...90
            mulDivRange = 10...20
        case "medium":
            addSubRange = 50...200
            mulDivRange = 20...30
        case "hard":
            addSubRange = 200...820
            mulDivRange = 30...50
        case "very hard":
            addSubRange = 200...2000
            mulDivRange = 50...60
        case "extra hard":
            addSubRange = 500...5000
            mulDivRange = 60...80
        default:
            addSubRange = 1...20
            mulDivRange = 1...10
        }

        switch finalTopic {
        case "Addition":
            firstNumber = Int.random(in: addSubRange)
            secondNumber = Int.random(in: addSubRange)
            correctAnswer = firstNumber + secondNumber
            currentOperation = "+"
        case "Subtraction":
            firstNumber = Int.random(in: addSubRange)
            secondNumber = Int.random(in: addSubRange)
            if secondNumber > firstNumber {
                swap(&firstNumber, &secondNumber)
            }
            correctAnswer = firstNumber - secondNumber
            currentOperation = "−"
        case "Multiplication":
            firstNumber = Int.random(in: mulDivRange)
            secondNumber = Int.random(in: mulDivRange)
            correctAnswer = firstNumber * secondNumber
            currentOperation = "×"
        case "Division":
            secondNumber = Int.random(in: mulDivRange)
            correctAnswer = Int.random(in: mulDivRange)
            firstNumber = correctAnswer * secondNumber
            currentOperation = "÷"
        default:
            firstNumber = Int.random(in: addSubRange)
            secondNumber = Int.random(in: addSubRange)
            correctAnswer = firstNumber + secondNumber
            currentOperation = "+"
        }

        choiceArray = generateAnswers()
    }

    func generateAnswers() -> [Int] {
        var answers = [correctAnswer]
        var incorrect = Set<Int>()

        while incorrect.count < 3 {
            let candidate = correctAnswer + Int.random(in: -10...10)
            if candidate != correctAnswer && candidate > 0 {
                incorrect.insert(candidate)
            }
        }

        answers.append(contentsOf: incorrect.shuffled())
        return answers.shuffled()
    }

    func getCurrentMixedOperator() -> String {
        return currentOperation
    }

    func answer(_ selected: Int) {
        isSelected = selected
        isAnswered = true
        totalQuestions += 1

        if selected == correctAnswer {
            score += 1
            correctAnswers += 1
        } else {
            score = max(score - 1, 0)
            incorrectAnswers += 1
        }
    }

    func startGame(difficulty: Difficulties) {
        if isGameInitialized { return }
        self.difficulty = difficulty
        score = 0
        totalQuestions = 0
        isGameOver = false
        isAnswered = false
        isSelected = 0
        isGameInitialized = true
        generateQuestion()
    }
    
    func timeFor(topic: String, difficulty: Difficulties, operation: String? = nil) -> Float {
        let topicLowercased = topic.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        switch topicLowercased {
        case "addition", "subtraction":
            switch difficulty {
            case .veryEasy: return 30
            case .easy: return 40
            case .medium: return 60
            case .hard: return 80
            case .veryHard: return 100
            case .extraHard: return 120
            }
        case "multiplication", "division":
            switch difficulty {
            case .veryEasy: return 40
            case .easy: return 50
            case .medium: return 70
            case .hard: return 90
            case .veryHard: return 110
            case .extraHard: return 130
            }
        case "mixed operations", "mixed":
            switch difficulty {
            case .veryEasy: return 45
            case .easy: return 55
            case .medium: return 75
            case .hard: return 95
            case .veryHard: return 115
            case .extraHard: return 135
            }
        default:
            return 60
        }
    }

    func endGame() {
        isGameOver = true
        timeIsUp = true
        isGameInitialized = false
        selectedScreen = .gameOver
    }
    
    func restartGame() {
        isGameInitialized = false
        score = 0
        correctAnswers = 0
        incorrectAnswers = 0
        totalQuestions = 0
        isAnswered = false
        isSelected = 0
        isGameOver = false
        timeIsUp = false
        generateQuestion()
    }

    func saveGameResult(gameTime: Double) {
        guard totalQuestions > 0 else { return }
        
        let result = GameResult()
        result.topic = selectedTopic
        result.level = selectedLevel
        result.gameTime = gameTime
        result.correctAnswers = correctAnswers
        result.incorrectAnswers = incorrectAnswers
        result.bestScore = scoresVM.currentTopScore(for: selectedTopic, difficulty: difficulty)
        result.gameDate = Date()
        
        RealmManager.shared.saveGameResult(result: result)
    }
}
