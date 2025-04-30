//
//  LevelsView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

struct LevelsView: View {
    @EnvironmentObject var navVM: NavigationViewModel

    let levels = ["Very easy", "Easy", "Medium", "Hard", "Very hard", "Extra hard"]
    
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
                    Button(action: {
                        navVM.selectedScreen = .topics
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
                Spacer()
            }
            
            VStack {
                Text("Levels")
                    .font(.custom("Kanit-Semibold", size: 60))
                    .foregroundColor(Color.darkBlue)
                    .offset(y:14)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 20)
                ], spacing: 17) {
                    ForEach(levels, id: \.self) { level in
                        Button(action: {
                            navVM.selectedLevel = level
                            navVM.generateQuestion()
                            navVM.selectedScreen = .game
                        }) {
                            HStack {
                                Text(level)
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

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        let scoresVM = ScoresViewModel()
        let navVM = NavigationViewModel()

        return LevelsView()
            .environmentObject(navVM)
            .environmentObject(scoresVM)
    }
}
