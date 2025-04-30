//
//  GameView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    @EnvironmentObject var timerVM: TimerViewModel
    @EnvironmentObject var scoresVM: ScoresViewModel
    
    @State private var isActive = true

    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [Color("LightBlue"), Color.white]),
                center: .center,
                startRadius: 0,
                endRadius: 720
            )
            .ignoresSafeArea()
            
            VStack {
                topBar
                Spacer()
                
                ZStack {
                    questionCard
                    
                    if navVM.isAnswered {
                        VStack {
                            Spacer()
                            NextButton(text: "Next") {
                                navVM.generateQuestion()
                                navVM.isAnswered = false
                            }
                            .offset(y: 10)
                        }
                        .frame(height: 560)
                        .transition(.scale)
                    }
                }
                .frame(height: 560)
                
                scoreSection
            }
            .onAppear {
                if !navVM.isGameInitialized || !isActive {
                    startNewGame()
                }
                isActive = true
            }
            .onDisappear {
                timerVM.stopTimer()
                isActive = false
            }
        }
    }
    
    private func startNewGame() {
        navVM.startGame(difficulty: navVM.difficulty)
        
        let duration = Double(navVM.timeFor(
            topic: navVM.selectedTopic,
            difficulty: navVM.difficulty,
            operation: navVM.currentOperation
        ))
        
        navVM.restartGame()
        timerVM.startTimer(duration: Float(duration))
        
        timerVM.onTimerFinish = {
            navVM.saveGameResult(gameTime: duration)
            navVM.endGame()
        }
    }
            
    var topBar: some View {
        HStack {
            Button(action: {
                navVM.selectedScreen = .start
                navVM.restartGame()
            }) {
                Image(systemName: "house")
                    .font(.system(size: 35))
                    .foregroundColor(.skyBlue)
                    .padding(.leading, 15)
            }

            Button(action: {
                navVM.selectedScreen = .levels
                navVM.restartGame()
            }) {
                Image("Back")
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 35, height: 35)
                    .foregroundColor(.skyBlue)
            }

            Spacer()

            HStack(spacing: 10) {
                Button(action: {
                    navVM.selectedScreen = .statistics
                    navVM.restartGame()
                }){
                    Image("Stats")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 41, height: 41)
                        .foregroundColor(.skyBlue)
                }
                Button(action: {
                    navVM.selectedScreen = .rules
                }){
                    Image(systemName: "info.circle")
                        .font(.system(size: 35))
                        .foregroundColor(.skyBlue)
                }
            }
            .padding(.trailing, 15)
        }
        .padding(.top, 5)
        .frame(maxWidth: .infinity)
    }

    var questionCard: some View {
        VStack {
            Text(timerVM.timeMessage)
                .font(.custom("Kanit-Regular", size: 45))
                .foregroundColor(Color.darkBlue)

            VStack {
                timerRing

                Text("\(navVM.firstNumber) \(navVM.currentOperation) \(navVM.secondNumber) = ?")
                    .font(.custom("KaiseiDecol-Bold", size: 24))
                    .foregroundColor(Color.darkBlue)

                answersGrid
            }
            .frame(width: 317, height: 386)
            .background(Color.white.opacity(0.55))
            .clipShape(RoundedRectangle(cornerRadius: 47))
            .padding(.bottom, 90)
        }
    }

    var answersGrid: some View {
        LazyVGrid(columns: [
            GridItem(.fixed(70), spacing: 25),
            GridItem(.fixed(70), spacing: 25)
        ], spacing: 25) {
            ForEach(navVM.choiceArray, id: \.self) { answer in
                Answers(number: answer)
                    .frame(width: 70, height: 70)
                    .onTapGesture {
                        if !navVM.isAnswered {
                            navVM.answer(answer)
                        }
                    }
            }
        }
    }

    var timerRing: some View {
        TimerView(timeRemaning: $timerVM.timeRemaining, progress: $timerVM.progress)
            .frame(width: 99, height: 99)
            .onAppear {
                timerVM.onTimerFinish = {
                    navVM.saveGameResult(gameTime: Double(navVM.timeFor(
                        topic: navVM.selectedTopic,
                        difficulty: navVM.difficulty,
                        operation: navVM.currentOperation
                    )))
                    navVM.endGame()
                }
            }
            .disabled(true)
    }

    var scoreSection: some View {
        VStack(spacing: 8) {
            Text("Score: \(navVM.score)")
                .font(.custom("Kanit-ExtraBold", size: 24))
                .foregroundColor(Color.darkBlue)

            Text("Top score: ☆\(scoresVM.currentTopScore(for: navVM.selectedTopic, difficulty: navVM.difficulty))")
            .font(.custom("Kanit-Regular", size: 20))
            .foregroundColor(Color("MediumBlue"))
            .padding(.bottom, 5)
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let scoresVM = ScoresViewModel()
        let timerVM = TimerViewModel()
        let navVM = NavigationViewModel()
        
        return GameView()
            .environmentObject(navVM)
            .environmentObject(scoresVM)
            .environmentObject(timerVM)
    }
}
