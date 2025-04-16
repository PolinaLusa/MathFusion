//
//  TimerView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI

struct TimerView: View {
    
    @Binding var timeRemaning: Float
    @Binding var progress: Float
    
    var body: some View {
        
        ZStack {
            
            Circle()
                .stroke(lineWidth: 5.0)
                .opacity(0.3)
                .foregroundColor(Color.gray)
            
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5.0))
                .overlay(content: {
                    Color.darkBlue
                        .mask {
                            Circle()
                                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                        }
                })
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.spring(), value: progress)
            
            Text("\(max(0, Int(timeRemaning))) sec")
                .font(.custom("Kaisei-Decol-Regular", size:24))
                .foregroundColor(Color.darkBlue)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(timeRemaning: .constant(4), progress: .constant(0.370))
    }
}
