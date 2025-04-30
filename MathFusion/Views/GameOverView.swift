//
//  GameOverView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 25.04.25.
//

import SwiftUI
import RealmSwift

struct GameOverView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    @EnvironmentObject var scoresVM: ScoresViewModel
    
    @State private var isNewTopScore: Bool = false
    
    var body: some View {
        ZStack {
            RadialGradient(
                gradient: Gradient(colors: [
                    Color("LightBlue"),
                    Color.white
                ]),
                center: .center,
                startRadius: 0,
                endRadius: 720
            )
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        navVM.selectedScreen = .start
                    }) {
                        Image(systemName: "house")
                            .font(.system(size: 35))
                            .foregroundColor(.skyBlue)
                            .padding(.leading,15)
                    }
                    Spacer()
                    HStack(spacing: 10) {
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
                Spacer()
            }
            
            VStack(spacing: 30) {
                Text("Game is ended!")
                    .font(.custom("Kanit-Regular", size: 45))
                    .foregroundColor(Color.darkBlue)
                
                VStack {
                    Text("Your score: \(navVM.score)")
                        .font(.custom("Kanit-Bold", size: 28))
                        .foregroundColor(Color.darkBlue)
                    
                    if isNewTopScore {
                        Text("New Top Score: ☆\(scoresVM.currentTopScore(for: navVM.selectedTopic, difficulty: navVM.difficulty))")
                            .font(.custom("Kanit-Regular", size: 24))
                            .foregroundColor(Color("MediumBlue"))
                            .padding(.bottom, 5)
                    } else {
                        Text("Top score: ☆ \(scoresVM.currentTopScore(for: navVM.selectedTopic, difficulty: navVM.difficulty))")
                            .font(.custom("Kanit-Regular", size: 24))
                            .foregroundColor(Color("MediumBlue"))
                    }
                }
                
                ZStack {
                    VStack(spacing: 25) {
                        Button(action: {
                            navVM.restartGame()
                            navVM.selectedScreen = .game
                        }) {
                            HStack {
                                Text("Restart")
                                    .font(.custom("Kanit-Bold", size: 36))
                                    .foregroundColor(.white)
                                    
                                Image("Restart")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 35, height: 35)
                                    .foregroundColor(.white)
                                    .padding(.leading, 40)
                            }
                            .frame(width: 258, height: 67)
                            .background(Color.darkBlue)
                            .cornerRadius(20)
                        }
                        
                        Button(action: {
                            navVM.selectedScreen = .statistics
                        }) {
                            HStack {
                                Text("Statistics")
                                    .font(.custom("Kanit-Bold", size: 36))
                                    .foregroundColor(.white)
                                
                                Image("Stats")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 39, height: 39)
                                    .foregroundColor(.white)
                                    .padding(.leading, 5)
                            }
                            .frame(width: 258, height: 67)
                            .background(Color.darkBlue)
                            .cornerRadius(20)
                        }
                        
                        Button(action: {
                            navVM.selectedScreen = .topics
                        }) {
                            Text("Change topic")
                                .font(.custom("Kanit-Bold", size: 36))
                                .foregroundColor(.white)
                                .frame(width: 258, height: 67)
                                .background(Color.darkBlue)
                                .cornerRadius(20)
                        }
                        
                        Button(action: {
                            navVM.selectedScreen = .levels
                        }) {
                            Text("Change level")
                                .font(.custom("Kanit-Bold", size: 36))
                                .foregroundColor(.white)
                                .frame(width: 258, height: 67)
                                .background(Color.darkBlue)
                                .cornerRadius(20)
                        }
                    }
                }
                .frame(width: 312, height: 377)
                .background(Color.white.opacity(0.55))
                .clipShape(RoundedRectangle(cornerRadius: 47, style: .continuous))
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            let result = GameResult()
            result.topic = navVM.selectedTopic
            result.level = navVM.selectedLevel
            result.correctAnswers = navVM.correctAnswers
            result.incorrectAnswers = navVM.incorrectAnswers
            result.bestScore = navVM.score
            result.gameDate = Date()
            
            RealmManager.shared.saveGameResult(result: result)
            
            let currentTop = scoresVM.currentTopScore(for: navVM.selectedTopic, difficulty: navVM.difficulty)
            if navVM.score > currentTop {
                scoresVM.updateTopScore(for: navVM.selectedTopic, difficulty: navVM.difficulty, score: navVM.score)
                isNewTopScore = true
            }
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        let scoresVM = ScoresViewModel()
        let navVM = NavigationViewModel()
       
        return GameOverView()
            .environmentObject(navVM)
            .environmentObject(scoresVM)
    }
}
