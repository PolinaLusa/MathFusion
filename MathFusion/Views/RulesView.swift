//
//  RulesView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 25.04.25.
//

import SwiftUI

struct RulesView: View {
    
    @EnvironmentObject var navVM: NavigationViewModel
    
    let rules = [
        "The game has 6 difficulty levels and 4 operations.",
        "Each level gives you a certain time - solve as many equations as you can!",
        "The more correct answers you give in the time limit, the better your result.",
        "The timer doesn't stop - no pausing allowed.",
        "Correct answers turn green, mistakes turn red with the correct solution shown.",
        "After each round, check your stats: speed and accuracy.",
        "Progress is saved separately for each operation.",
        "You can replay levels to beat your high score."
    ]
    
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
                            .padding(.leading, 15)
                    }
                    Spacer()
                }
                .padding(.top, 5)
                
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 10) {
                        Text("Rules")
                            .font(.custom("Kanit-Semibold", size: 45))
                            .foregroundColor(Color.darkBlue)

                        VStack(alignment: .leading, spacing: 3) {
                            ForEach(Array(rules.enumerated()), id: \.offset) { index, rule in
                                HStack(alignment: .top, spacing: 1) {
                                    Text("\(index + 1).")
                                        .font(.custom("KaiseiDecol-Bold", size: 20))
                                        .foregroundColor(.darkBlue)
                                    
                                    Text(rule)
                                        .font(.custom("KaiseiDecol-Regular", size: 20))
                                        .foregroundColor(.darkBlue)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.55))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct RulesView_Previews: PreviewProvider {
    static var previews: some View {
        let navVM = NavigationViewModel()
        return RulesView()
            .environmentObject(navVM)
    }
}
