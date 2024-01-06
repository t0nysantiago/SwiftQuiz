//
//  LeaderboardView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 26/12/23.
//

import SwiftUI
import SwiftData
import NavigationTransitions

struct LeaderboardView: View {
    @State private var backToHome: Bool = false
    @State private var selectedTime: SortTime = .today
    @State private var usersData: [User] = []
    @State private var pointsData: [Points] = []
    @State private var userDataDictionary: [User: [String: Int]] = [:]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationView {
            ScrollView (showsIndicators: false) {
                ZStack{
                    Color.appWhite.ignoresSafeArea()
                    VStack{
                        HStack{
                            Image(systemName: "chevron.backward.circle")
                                .font(.system(size: 30))
                                .foregroundStyle(Color.appOrange)
                                .onTapGesture {
                                    backToHome = true
                                }
                                .navigationDestination(isPresented: $backToHome){
                                    HomeView()
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
                        
                        Spacer(minLength: 35)
                        
                        ForEach(userDataDictionary.sorted(by: { $0.value[selectedTime.rawValue, default: 0] > $1.value[selectedTime.rawValue, default: 0] }).prefix(10), id: \.key) { (user, points) in
                            RankingView(user: user, points: points, selectedTime: selectedTime)
                                .padding(.horizontal, 20)
                        }
                        
                        Spacer()
                        
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                .onAppear {
                    let users = fetchUsersData()
                    let points = fetchPointsData()
                    
                    let todayPoints = calculatePointsForToday(points: points)
                    let lastSevenDaysPoints = calculatePointsForLastSevenDays(points: points)
                    let totalPoints = calculateTotalPoints(points: points)
                    
                    for user in users {
                        var userPoints: [String: Int] = [:]
                        
                        userPoints["Today"] = todayPoints[user.id] ?? 0
                        userPoints["Week"] = lastSevenDaysPoints[user.id] ?? 0
                        userPoints["All Time"] = totalPoints[user.id] ?? 0
                        
                        userDataDictionary[user] = userPoints
                    }
                }
            }
            .background(.appWhite)
            .scrollContentBackground(.hidden)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationTransition(.slide)
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
    
    func fetchPointsData() -> [Points] {
        let fetchDescriptor = FetchDescriptor<Points>()
        var points: [Points] = []
        do {
            points = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Fetch failed")
        }
        return points
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

struct RankingView: View {
    let user: User
    let points: [String: Int]
    let selectedTime: SortTime
    @State private var radius: Double = 50.0

    var body: some View {
        HStack {
            Image(user.img_name)
                .resizable()
                .frame(width: radius, height: radius)
                .foregroundColor(.appOrange)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.appOrange, lineWidth: 2))
                .padding(.horizontal, 5)
            
            Text(user.username)
            
            Spacer()
            
            if let selectedPoints = points[selectedTime.rawValue] {
                Text("\(selectedPoints)").padding(.horizontal, 5)
            } else {
                Text("N/A").padding(.horizontal, 5)
            }
        }
    }
}
