//
//  TopicView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

struct TopicView: View {
    
    @EnvironmentObject var gameVM: GameViewModel
    @EnvironmentObject var navVM: NavigationViewModel

    let topics = ["Addition", "Subtraction", "Division", "Multiplication", "Mixed operations"]
    
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
                HStack {
                    Button(action: {
                        navVM.selectedScreen = .start
                    }) {
                        Image(systemName: "house")
                            .font(.system(size: 39))
                            .foregroundColor(.skyBlue)
                            .padding(.leading,10)
                    }
                    Spacer()
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
                    .padding(.trailing, 10)
                }
                .padding(.top, 5)
                .frame(maxWidth: .infinity)
                Spacer()
            }
            
            VStack {
                Text("Choose topic")
                    .font(.custom("Kanit-Semibold", size: 60))
                    .foregroundColor(Color.darkBlue)
                    .offset(y:-12)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 20)
                ], spacing: 25) {
                    ForEach(topics, id: \.self) { topic in
                        Button(action: {
                            gameVM.selectedTopic = topic
                            navVM.selectedScreen = .levels
                        }) {
                            HStack {
                                Text(topic)
                                    .font(.custom("KaiseiDecol-Regular", size: 29))
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Image("RightArrow")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 41, height: 41)
                                    .foregroundColor(.deepBlue)
                                    .padding(.trailing,19)
                            }
                            .frame(width:339.43, height:67, alignment: .leading)
                            .padding(.leading, 25)
                            .background(Color.deepBlue)
                            .cornerRadius(20)
                        }
                    }
                }
                .offset(y: -40)
            }
        }
    }
}

struct TopicView_Previews: PreviewProvider {
    static var previews: some View {
        let scoresVM = ScoresViewModel()
        scoresVM.loadScores()
        let timerVM = TimerViewModel()
        
        let gameVM = GameViewModel(difficulty: 20, timerVM: timerVM, scoresVM: scoresVM)

        return TopicView()
            .environmentObject(gameVM)
            .environmentObject(NavigationViewModel())
            .environmentObject(scoresVM)
    }
}
