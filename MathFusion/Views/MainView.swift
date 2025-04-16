//
//  MainView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 14.04.25.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var gameVM: GameViewModel
    @EnvironmentObject var timerVM: TimerViewModel
    @EnvironmentObject var navVM: NavigationViewModel
    @EnvironmentObject var scoresVM: ScoresViewModel
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [
                    Color("LightBlue"),
                    Color("White")
                ]),
                center: .center,
                startRadius: 0,
                endRadius: 720
            )
            .ignoresSafeArea()
            
            VStack {
                HStack(spacing: 10) {
                    Image("Stats")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 41, height: 41)
                        .foregroundColor(.skyBlue)
                    
                    Image(systemName: "gearshape")
                        .font(.system(size: 41))
                        .foregroundColor(.skyBlue)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
                .padding(.top, 5)
                
                Spacer()
            }
            
            VStack {
                Text("Math Fusion")
                    .font(.custom("Kanit-Semibold", size: 60))
                    .foregroundColor(Color.darkBlue)
                    .padding(.top, 80)
                
                Spacer()
            }
            
            ZStack {
                VStack {
                    timerRing
                    
                    Text("\(Int.random(in: 1...50)) + \(Int.random(in: 8...50)) = ?")
                        .font(.custom("KaiseiDecol-Bold", size: 24))
                        .foregroundColor(Color.darkBlue)
                    
                    LazyVGrid(columns: [
                        GridItem(.fixed(70), spacing: 25),
                        GridItem(.fixed(70), spacing: 25)
                    ], spacing: 25) {
                        ForEach(0..<4) { num in
                            Answers(number: Int.random(in: 0...100))
                                .frame(width: 70, height: 70)
                        }
                    }
                }
            }
            .frame(width: 317, height: 386)
            .background(Color.white.opacity(0.55))
            .foregroundColor(.darkBlue)
            .clipShape(RoundedRectangle(cornerRadius: 47, style: .continuous))
            .clipped()
            
            Button {
                gameVM.generateQuestion()
                gameVM.generateAnswers()
                timerVM.resetTimer()
                navVM.selectedScreen = .topics
            } label: {
                StartButton(text: "Start")
            }
            .offset(y: 300)
            
            Text("Top score: ☆\(scoresVM.currentTopScore(for: gameVM.difficulty))")
                .font(.custom("Kanit-Regular", size: 20))
                .foregroundColor(Color("MediumBlue"))
                .offset(y:350)
        }
    }
    
    var timerRing: some View {
        TimerView(timeRemaning: $timerVM.timeRemaining,
                  progress: $timerVM.progress)
        .frame(width: 99, height: 99)
        .cornerRadius(47)
        .onAppear(perform: {
            timerVM.resetTimer()
        })
        .onReceive(timerVM.timerPublisher) { _ in
            if navVM.selectedScreen == .start {
                timerVM.timeRemaining -= 1
                timerVM.progress = Float(1 - (timerVM.timeRemaining / 5.0))
                
                if timerVM.timeRemaining < 0 {
                    timerVM.timeRemaining = 5
                    timerVM.progress = 0
                }
            }
        }
        .disabled(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let scoresVM = ScoresViewModel()
        scoresVM.loadScores()
        
        let timerVM = TimerViewModel()
        let gameVM = GameViewModel(difficulty: 20, timerVM: timerVM, scoresVM: scoresVM)
        
        return MainView()
            .environmentObject(timerVM)
            .environmentObject(gameVM)
            .environmentObject(NavigationViewModel())
            .environmentObject(scoresVM)
    }
}
