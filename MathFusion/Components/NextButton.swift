//
//  NextButton.swift
//  MathFusion
//
//  Created by Полина Лущевская on 17.04.25.
//

import SwiftUI

struct NextButton: View {

    @EnvironmentObject var logic: NavigationViewModel
    
    var text: String
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()         
        }) {
            Text(text)
                .frame(width: 258, height: 67)
                .font(.custom("Kanit-SemiBold", size: 48))
                .background(Color(logic.difficulty.rawValue == text ? "SkyBlue" : "DarkBlue"))
                .foregroundColor(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {

        return NextButton(text: "Next", action: {
            print("Next tapped")
        })
    }
}
