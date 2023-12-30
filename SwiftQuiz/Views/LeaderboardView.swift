//
//  LeaderboardView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 26/12/23.
//

import SwiftUI

struct LeaderboardView: View {
    @State private var selectedTime: SortTime = .today
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack{
            Color.appWhite.ignoresSafeArea()
            VStack{
                
                HStack{
                    
                    Image(systemName: "chevron.backward.circle")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.appOrange)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    
                    Spacer()
                    
                    Text("Leaderboard")
                        .font(.system(size: 25, design: .rounded))
                        .foregroundStyle(Color.black)
                        .bold()
                        .padding()
                    
                    Spacer(minLength: 90)
                }.padding(.horizontal, 20)
                
                HStack (spacing: -10) {
                    ForEach(SortTime.allCases, id: \.self) { timing in
                        Button(action: {
                            selectedTime = timing
                        }) {
                            ZStack{
                                Text(timing.rawValue)
                                    .foregroundColor(timing == selectedTime ? Color.appWhite : Color.black)
                                    .font(.system(size: 16, design: .rounded))
                                    .cornerRadius(15)
                            }
                            .frame(width: 110, height: 40)
                            .background(RoundedRectangle(cornerRadius: 15.0))
                            .foregroundStyle(timing == selectedTime ? Color.appOrange : Color.clear)
                        }
                    }
                }
                
                Spacer(minLength: 60)
                
                HStack (alignment: .center, spacing: 30) {
                    TopWinnersCircle(radius: .constant(80.0), ranking: .constant(Ranking.second))
                    TopWinnersCircle(radius: .constant(120.0), ranking: .constant(Ranking.first))
                    TopWinnersCircle(radius: .constant(80.0), ranking: .constant(Ranking.third))
                }
                
                Spacer(minLength: 30)
                
                ForEach(0..<6) { index in
                    RankingView(radius: .constant(50.0))
                }.padding(10)
                
                Spacer()
                
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct TopWinnersCircle: View {
    @Binding var radius: Double
    @Binding var ranking: Ranking
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: radius, height: radius)
                .foregroundColor(circleColor(for: ranking))
            
            Circle()
                .frame(width: radius * 0.95, height: radius * 0.95)
                .foregroundColor(.white)
            
            if ranking == Ranking.first {
                Text("👑")
                    .font(.system(size: 30))
                    .offset(y: -80)
                
                TopWinnersFoot(ranking: .constant(Ranking.first), position: .constant(CGSize(width: 0.0, height: 55.0)), colorCircle: .constant(.yellow))
            } else {
                TopWinnersFoot(ranking: ranking == Ranking.second ? .constant(Ranking.second) : .constant(Ranking.third), position: .constant(CGSize(width: 0.0, height: 35.0)), colorCircle: ranking == Ranking.second ? .constant(.gray) : .constant(.brown))
            }
        }
    }
    
    func circleColor(for ranking: Ranking) -> Color {
        switch ranking {
        case .first:
            return Color.yellow
        case .second:
            return Color.gray
        case .third:
            return Color.brown
        }
    }
}

struct TopWinnersFoot: View {
    @Binding var ranking: Ranking
    @Binding var position: CGSize
    @Binding var colorCircle: Color
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 35, height: 35)
                .foregroundStyle(colorCircle)
                .offset(position)
            
            Text("\(ranking.rawValue)")
                .font(.system(size: 18, design:.rounded))
                .foregroundStyle(.appWhite)
                .bold()
                .offset(position)
        }
    }
}

struct RankingView: View {
    @Binding var radius: Double
    var body: some View {
        HStack {
            VStack {
                Text("\(13)")
                Image(systemName: "chevron.up")
                    .foregroundStyle(.green)
            }
            
            Circle()
                .frame(width: radius, height: radius)
                .foregroundStyle(.appOrange)
                .padding(.horizontal, 5)
            
            Text("Username People")
            
            Spacer()
            
            Text("\(1932)")
        }.padding(.horizontal, 30)
    }
}

enum SortTime: String, CaseIterable, Identifiable {
    case today = "Today", week = "Week", alltime = "All Time"
    var id: Self { self }
}

enum Ranking: Int, CaseIterable, Identifiable {
    case first = 1, second, third
    var id: Self { self }
}
