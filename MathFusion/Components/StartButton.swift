//
//  TextButton.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

struct StartButton: View {
    
    @EnvironmentObject var logic: GameViewModel
    
    var text: String
    
    var body: some View {
        
        Text(text)
            .frame(width:258, height: 67)
            .font(.custom("Kanit-SemiBold", size: 48))
            .background(Color(logic.difficulty.rawValue == text ? "SkyBlue" : "DarkBlue"))
            .foregroundColor(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct StartButton_Previews: PreviewProvider {
    static var previews: some View {
        let scoresVM = ScoresViewModel()
        scoresVM.loadScores()
        let timerVM = TimerViewModel()

        let gameVM = GameViewModel(difficulty: 20, timerVM: timerVM, scoresVM: scoresVM)

        return StartButton(text: "Start")
            .environmentObject(gameVM)
    }
}
