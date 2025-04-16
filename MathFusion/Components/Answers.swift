//
//  Answers.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

struct Answers: View{
    
    @EnvironmentObject var logic: GameViewModel
       
       var number:Int
       
       var backgroundColor: Color {
           if logic.isAnswered {
               if number == logic.isSelected && number != logic.correctAnswer || logic.isSelected == Int() && number == logic.correctAnswer {
                   return .red
               } else if number == logic.isSelected && number == logic.correctAnswer || number == logic.correctAnswer {
                   return .green
               } else {
                   return .gray
               }
           } else {
               return Color("buttonBack")
           }
       }
       
       var body: some View {
           
           Text("\(number)")
               .frame(width: 70, height: 70)
               .font(.custom("KaiseiDecol-Bold", size: 24))
               .background(Color.darkBlue)
               .foregroundColor(Color.white)
               .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
       }
}
