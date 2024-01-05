//
//  LeaderboardView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 26/12/23.
//

import SwiftUI
import SwiftData

struct LeaderboardView: View {
    @State private var selectedTime: SortTime = .today
    @State private var usersData: [User] = []
    @State private var pointsData: [Points] = []
    @State private var userDataDictionary: [String: [String: Int]] = [:]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        
        ScrollView (showsIndicators: false) {
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
                    }.padding(.horizontal)
                    
                    HStack (spacing: -10) {
                        ForEach(SortTime.allCases, id: \.self) { timing in
                            Button(action: {
                                selectedTime = timing
                                sortDictionary(by: timing)
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
                        TopWinnersCircle(ranking: .constant(Ranking.second))
                        TopWinnersCircle(ranking: .constant(Ranking.first))
                        TopWinnersCircle(ranking: .constant(Ranking.third))
                    }
                    
                    Spacer(minLength: 30)
                    
                    ForEach(4..<11) { index in
                        RankingView(position: .constant(index))
                    }.padding(10).padding(.horizontal, 30)
                    
                    Spacer()
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .frame(width: UIScreen.main.bounds.width)
            .onAppear {
                let users = fetchUsersData()
                let points = fetchUsersPointsData()
                
                let todayPoints = calculatePointsForToday(points: points)
                let lastSevenDaysPoints = calculatePointsForLastSevenDays(points: points)
                let totalPoints = calculateTotalPoints(points: points)
                
                for user in users {
                    var userPoints: [String: Int] = [:]
                    
                    userPoints["today"] = todayPoints[user.id] ?? 0
                    userPoints["week"] = lastSevenDaysPoints[user.id] ?? 0
                    userPoints["allTime"] = totalPoints[user.id] ?? 0
                    
                    userDataDictionary[user.username] = userPoints
                }
                
                let sortedData = userDataDictionary.sorted { $0.value["today", default: 0] > $1.value["today", default: 0] }
                userDataDictionary = Dictionary(uniqueKeysWithValues: sortedData)
            }
        }
        .background(.appWhite)
        .scrollContentBackground(.hidden)
    }
    
    func fetchUsersData() -> [User] {
        let fetchDescriptor = FetchDescriptor<User>()
        var users: [User] = []
        do {
            users = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Fetch failed")
        }
        return users
    }

    func fetchUsersPointsData() -> [Points] {
        let fetchDescriptor = FetchDescriptor<Points>()
        var points: [Points] = []
        do {
            points = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Fetch failed")
        }
        return points
    }

    func calculatePointsForToday(points: [Points]) -> [String: Int] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let currentDate = dateFormatter.string(from: Date())

        var todayPoints: [String: Int] = [:]

        for point in points {
            let pointDate = dateFormatter.string(from: point.date)

            if currentDate == pointDate {
                if let existingPoints = todayPoints[point.userId] {
                    todayPoints[point.userId] = existingPoints + point.point
                } else {
                    todayPoints[point.userId] = point.point
                }
            }
        }

        return todayPoints
    }

    func calculatePointsForLastSevenDays(points: [Points]) -> [String: Int] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()

        var lastSevenDaysPoints: [String: Int] = [:]

        for point in points {
            if point.date >= sevenDaysAgo {
                if let existingPoints = lastSevenDaysPoints[point.userId] {
                    lastSevenDaysPoints[point.userId] = existingPoints + point.point
                } else {
                    lastSevenDaysPoints[point.userId] = point.point
                }
            }
        }

        return lastSevenDaysPoints
    }

    func calculateTotalPoints(points: [Points]) -> [String: Int] {
        var totalPoints: [String: Int] = [:]

        for point in points {
            if let existingPoints = totalPoints[point.userId] {
                totalPoints[point.userId] = existingPoints + point.point
            } else {
                totalPoints[point.userId] = point.point
            }
        }

        return totalPoints
    }

    func sortDictionary(by timing: SortTime) {
        switch timing {
        case .today:
            let sortedData = userDataDictionary.sorted { $0.value["today", default: 0] > $1.value["today", default: 0] }
            userDataDictionary = Dictionary(uniqueKeysWithValues: sortedData)
        case .week:
            let sortedData = userDataDictionary.sorted { $0.value["week", default: 0] > $1.value["week", default: 0] }
            userDataDictionary = Dictionary(uniqueKeysWithValues: sortedData)
        case .alltime:
            let sortedData = userDataDictionary.sorted { $0.value["allTime", default: 0] > $1.value["allTime", default: 0] }
            userDataDictionary = Dictionary(uniqueKeysWithValues: sortedData)
        }
    }
}

struct UserPointsMap {
    var username: String
    var totalPoints: Int
}

struct TopWinnersCircle: View {
    @Binding var ranking: Ranking
    private var radius: Double
    
    init(ranking: Binding<Ranking>) {
        self._ranking = ranking
        self.radius = ranking.wrappedValue.rawValue == Ranking.first.rawValue ? 120 : 80
    }
    
    var body: some View {
        VStack {
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
            .padding(.bottom)
            
            Text("Username")
            Text("2000")
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
    @Binding var position: Int
    @State private var radius: Double = 50.0
    var body: some View {
        HStack {
            Text("\(position)")
            
            Circle()
                .frame(width: radius, height: radius)
                .foregroundStyle(.appOrange)
                .padding(.horizontal, 5)
            
            Text("Username People")
            
            Spacer()
            
            Text("\(1932)")
        }
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

//#Preview {
//    LeaderboardView()
//}
