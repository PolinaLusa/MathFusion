//
//  MainView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 14.04.25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var timerVM: TimerViewModel
    @EnvironmentObject var navVM: NavigationViewModel
    @EnvironmentObject var scoresVM: ScoresViewModel
    
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
                HStack(spacing: 10) {
                    Button(action: {
                        navVM.selectedScreen = .statistics
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
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 15)
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
                .frame(width: 317, height: 386)
                .background(Color.white.opacity(0.55))
                .foregroundColor(.darkBlue)
                .clipShape(RoundedRectangle(cornerRadius: 47, style: .continuous))
            }
            
            Button {
                navVM.generateQuestion()
                navVM.selectedScreen = .topics
            } label: {
                StartButton(text: "Start")
            }
            .offset(y: 300)
        }
    }
    
    var timerRing: some View {
        TimerView(timeRemaning: $timerVM.timeRemaining,
                 progress: $timerVM.progress)
        .frame(width: 99, height: 99)
        .onAppear {
            timerVM.startTimer(duration: 60)
        }
        .disabled(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let scoresVM = ScoresViewModel()
        let timerVM = TimerViewModel()
        let navVM = NavigationViewModel()

        return MainView()
            .environmentObject(timerVM)

            .environmentObject(navVM)
            .environmentObject(scoresVM)
    }
}
