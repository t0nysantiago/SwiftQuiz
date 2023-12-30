//
//  HomeView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack (alignment: .leading){
                Color.appWhite.ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    TopHomeView()
                    
                    Spacer()
                    
                    CardView(difficult: .constant(Difficult.easy), status: .constant(PhaseStatus.finished), cardColor: .constant(Color.appGreen), gradientColor: .constant(Color.green), imageSet: .constant("history"))
                    
                    CardView(difficult: .constant(Difficult.medium), status: .constant(PhaseStatus.open), cardColor: .constant(Color.appPurple), gradientColor: .constant(Color.blue), imageSet: .constant("science"))
                    
                    CardView(difficult: .constant(Difficult.hard), status: .constant(PhaseStatus.block), cardColor: .constant(Color.appOrange), gradientColor: .constant(Color.red), imageSet: .constant("sports"))
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct CardView: View {
    @Binding var difficult: Difficult
    @Binding var status: PhaseStatus
    @Binding var cardColor: Color
    @Binding var gradientColor: Color
    @Binding var imageSet: String
    var body: some View {
        NavigationLink(destination: BeforeStartView(backgroundColorChoosed: .constant(cardColor), logoImage: .constant(imageSet), difficult: .constant(difficult))) {
            ZStack (alignment: .leading) {
                Rectangle()
                    .frame(width: 330, height: 150)
                    .foregroundColor(.clear)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [cardColor, gradientColor]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .padding(.top, 60)
                VStack (alignment: .leading, spacing: 1){
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.appWhite, lineWidth: 1)
                            .frame(width: 35, height: 35)
                        
                        Image(imageSet)
                            .resizable()
                            .frame(width: 110, height: 100)
                            .offset(x: 170, y: -30)
                        
                        switch status {
                        case .open:
                            Image(systemName: "play.fill")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 10)
                        case .finished:
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 8)
                        case .block:
                            Image(systemName: "lock.fill")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 9)
                        }
                    }.padding(.top, 30)
                    
                    Text(difficult.rawValue)
                        .font(.system(size: 18, design: .rounded))
                        .foregroundStyle(Color.appWhite)
                    
                    Text(status.rawValue)
                        .font(.system(size: 30, design: .rounded))
                        .bold()
                        .foregroundStyle(Color.appWhite)
                    
                }.padding(.leading, 25)
            }
        }
    }
}

struct TopHomeView: View {
    @State private var isLeaderboardViewActive = false
    @State private var isUserViewActive = false
    var body: some View {
        ZStack {
            HStack {
                VStack (alignment: .leading, spacing: 10) {
                    Text("Let's Play")
                        .font(.system(size: 30, design: .rounded))
                        .foregroundStyle(.appOrange)
                        .bold()
                    
                    Text("Go for the top!")
                        .font(.system(size: 18, design: .rounded))
                        .foregroundStyle(.gray)
                }
                
                NavigationLink(
                    destination: LeaderboardView(),
                    isActive: $isLeaderboardViewActive,
                    label: {
                        EmptyView()
                    }
                )
                
                NavigationLink(
                    destination: UserView(),
                    isActive: $isUserViewActive,
                    label: {
                        EmptyView()
                    }
                )
                
                Spacer()
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(.appOrange)
                    .padding()
                    .onTapGesture {
                        isLeaderboardViewActive = true
                    }
                
                Image(systemName: "person.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.appOrange)
                    .onTapGesture {
                        isUserViewActive = true
                    }
                
            }.padding(.horizontal, 10)
        }
    }
}

enum Difficult: String, CaseIterable, Identifiable {
    case easy = "Easy", medium = "Medium", hard = "Hard"
    var id: Self { self }
}

enum PhaseStatus: String, CaseIterable, Identifiable {
    case open = "Continue", finished = "Finished", block = "Blocked"
    var id: Self { self }
}
