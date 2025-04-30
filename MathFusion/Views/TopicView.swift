//
//  TopicView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

struct TopicView: View {
    @EnvironmentObject var navVM: NavigationViewModel

    let topics = ["Addition", "Subtraction", "Division", "Multiplication", "Mixed operations"]
    
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
                Text("Choose topic")
                    .font(.custom("Kanit-Semibold", size: 60))
                    .foregroundColor(Color.darkBlue)
                    .offset(y:-12)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 20)
                ], spacing: 25) {
                    ForEach(topics, id: \.self) { topic in
                        Button(action: {
                            navVM.selectedTopic = topic
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
        
        return TopicView()
            .environmentObject(NavigationViewModel())
            .environmentObject(scoresVM)
    }
}
