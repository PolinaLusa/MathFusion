//
//  Answers.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

struct Answers: View {
    @EnvironmentObject var navVM: NavigationViewModel
    var number: Int
    
    var backgroundColor: Color {
        if navVM.isAnswered {
            if number == navVM.correctAnswer {
                return .green
            } else if number == navVM.isSelected {
                return .red
            } else {
                return .gray.opacity(0.4)
            }
        } else {
            return Color("DarkBlue")
        }
    }

    var body: some View {
        Text("\(number)")
            .frame(width: 70, height: 70)
            .font(.custom("KaiseiDecol-Bold", size: 24))
            .background(backgroundColor)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
