//
//  StatsView.swift
//  MathFusion
//
//  Created by Полина Лущевская on 16.04.25.
//

import SwiftUI
import RealmSwift
import Charts

struct StatsView: View {
    
    @EnvironmentObject var navVM: NavigationViewModel
    
    @State private var selectedLevel = "Medium"
    @State private var selectedTopic = "Addition"
    
    @ObservedResults(GameResult.self) var gameResults
    
    let levels = ["Very easy", "Easy", "Medium", "Hard", "Very hard", "Extra hard"]
    let topics = ["Addition", "Subtraction", "Multiplication", "Division", "Mixed operations"]
    
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
                    Button(action: {
                        navVM.selectedScreen = .rules
                    }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 35))
                            .foregroundColor(.skyBlue)
                    }
                    .padding(.trailing, 15)
                }
                .padding(.top, 5)
                
                ScrollView(showsIndicators: true) {
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            Menu {
                                Picker("", selection: $selectedTopic) {
                                    ForEach(topics, id: \.self) { topic in
                                        Text(topic).tag(topic)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedTopic)
                                        .font(.custom("KaiseiDecol-Bold", size: 18))
                                        .foregroundColor(.white)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                }
                                .padding(10)
                                .frame(width: 150)
                                .background(Color.darkBlue)
                                .cornerRadius(40)
                            }

                            Menu {
                                Picker("", selection: $selectedLevel) {
                                    ForEach(levels, id: \.self) { level in
                                        Text(level).tag(level)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedLevel)
                                        .font(.custom("KaiseiDecol-Bold", size: 18))
                                        .foregroundColor(.white)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.white)
                                }
                                .padding(10)
                                .frame(width: 140)
                                .background(Color.darkBlue)
                                .cornerRadius(40)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        Text("Statistics")
                            .font(.custom("Kanit-Semibold", size: 45))
                            .foregroundColor(Color.darkBlue)
                        
                        LevelTopicStatsView(
                            level: selectedLevel,
                            topic: selectedTopic,
                            gameResults: gameResults
                        )
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct LevelTopicStatsView: View {
    let level: String
    let topic: String
    let gameResults: Results<GameResult>
    
    struct ChartDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let accuracy: Double
    }
    
    var filteredResults: [GameResult] {
        gameResults.filter { $0.topic == topic && $0.level == level }
    }
    
    var totalSolved: Int {
        filteredResults.reduce(0) { $0 + $1.correctAnswers }
    }
    
    var totalAttempts: Int {
        filteredResults.reduce(0) { $0 + $1.correctAnswers + $1.incorrectAnswers }
    }
    
    var accuracy: Double {
        totalAttempts > 0 ? Double(totalSolved) / Double(totalAttempts) * 100 : 0
    }
    
    var lastGame: GameResult? {
        filteredResults.sorted { $0.gameDate > $1.gameDate }.first
    }

    var lastCorrect: Int {
        lastGame?.correctAnswers ?? 0
    }

    var lastIncorrect: Int {
        lastGame?.incorrectAnswers ?? 0
    }

    var totalIncorrect: Int {
        filteredResults.reduce(0) { $0 + $1.incorrectAnswers }
    }
    
    var bestScore: Int {
            filteredResults.map { $0.correctAnswers }.max() ?? 0
    }
    
    var chartData: [ChartDataPoint] {
        let oneWeekAgo = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        return filteredResults
            .filter { $0.gameDate >= oneWeekAgo } 
            .map { result in
                let total = result.correctAnswers + result.incorrectAnswers
                let acc = total > 0 ? Double(result.correctAnswers) / Double(total) * 100 : 0
                return ChartDataPoint(date: result.gameDate, accuracy: acc)
            }
            .sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("\(topic) · \(level)")
                .font(.custom("KaiseiDecol-Bold", size: 22))
                .foregroundColor(.darkBlue)
                .padding(.leading, 30)
            StatRow(title: "Top score: ", value: "☆ \(bestScore)")
            StatRow(title: "Solved:", value: "\(totalSolved) problems")
            StatRow(title: "Accuracy:", value: String(format: "%.1f%%", accuracy))
            StatRow(title: "Correct (last):", value: "\(lastCorrect)")
            StatRow(title: "Wrong (last):", value: "\(lastIncorrect)")
            StatRow(title: "Correct (total):", value: "\(totalSolved)")
            StatRow(title: "Wrong (total):", value: "\(totalIncorrect)")
            
            if !chartData.isEmpty {
                Chart(chartData) { point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Accuracy", point.accuracy)
                    )
                    .foregroundStyle(Color.gray)
                    .symbol(Circle())
                }
                .chartYScale(domain: 0...100)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: max(1, chartData.count / 5))) { value in
                        if let date = value.as(Date.self) {
                            AxisValueLabel {
                                VStack {
                                    Text(date, format: .dateTime.day(.twoDigits))
                                    Text(date, format: .dateTime.month(.abbreviated))
                                }
                                .font(.system(size: 10))
                            }
                        }
                        AxisGridLine()
                        AxisTick()
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
                .chartYAxisLabel("Accuracy (%)", position: .leading)
                .chartXAxisLabel("Date")
                .frame(height: 250)
                .padding(.horizontal, 10)
            } else {
                Text("No data available for this topic & level")
                    .font(.custom("KaiseiDecol-Regular", size: 16))
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding()
        .background(Color.white.opacity(0.55))
        .cornerRadius(47)
        .padding(.horizontal, 25)
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("KaiseiDecol-Regular", size: 18))
                .foregroundColor(.darkBlue)
            
            Spacer()
            
            Text(value)
                .font(.custom("KaiseiDecol-Bold", size: 18))
                .foregroundColor(.darkBlue)
        }
        .padding(.horizontal, 10)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        let navVM = NavigationViewModel()
        return StatsView().environmentObject(navVM)
    }
}
