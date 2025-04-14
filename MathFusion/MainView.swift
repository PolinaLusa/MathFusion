//
//  MainView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 14.04.25.
//

import SwiftUI

struct MainView: View {
    @State private var timerPulse = false
    @State private var timeRemaining = 5
    @State private var totalTime = 5
    @State private var timer: Timer?
    
    private var progressValue: CGFloat {
        CGFloat(timeRemaining) / CGFloat(totalTime)
    }
    
    private var animation: Animation {
        timeRemaining > 1 ? .linear(duration: 1) : .linear(duration: 0.6)
    }
    
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
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
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
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 317, height: 386)
                    .cornerRadius(47)
                    .opacity(0.5)
                VStack {
                    Text("\(Int.random(in: 1...50)) + \(Int.random(in: 8...50)) = ?")
                        .font(.custom("KaiseiDecol-Bold", size: 24))
                        .foregroundColor(Color.darkBlue)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 10)], spacing: 10) {

//                                        ForEach(0..<4) { num in
//                                            AnswerButton(number: Int.random(in: 0...100))
                                        }
                                    }
                
                VStack {
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 5)
                            .frame(width: 99, height: 99)
                        
                        Circle()
                            .trim(from: 0, to: progressValue)
                            .stroke(Color.darkBlue, lineWidth: 7)
                            .frame(width: 99, height: 99)
                            .rotationEffect(.degrees(-90))
                            .animation(animation, value: timeRemaining)
                        
                        Text("\(timeRemaining) sec")
                            .font(.custom("KaiseiDecol-Regular", size: 24))
                            .foregroundColor(Color.darkBlue)
                    }
                    .padding(.top, 35)
                    
                    Spacer()
                }
                .frame(width: 317, height: 386)
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        timeRemaining = totalTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                startTimer()
            }
        }
    }
}

#Preview {
    MainView()
}
