//
//  HomeView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var phasesOfUser: Phases?
    @EnvironmentObject var userSettings: UserSettings
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .leading){
                Color.appWhite.ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    TopHomeView()
                    
                    Spacer()
                    if let userPhases = phasesOfUser {
                        CardView(difficult: .constant(Difficult.easy), status: .constant(userPhases.easy), cardColor: .constant(Color.appGreen), gradientColor: .constant(Color.green), imageSet: .constant(randomStringImg()))
                    }
                    
                    if let userPhases = phasesOfUser {
                        CardView(difficult: .constant(Difficult.medium), status: .constant(userPhases.medium), cardColor: .constant(Color.appPurple), gradientColor: .constant(Color.blue), imageSet: .constant(randomStringImg()))
                    }
                    
                    if let userPhases = phasesOfUser {
                        CardView(difficult: .constant(Difficult.hard), status: .constant(userPhases.hard), cardColor: .constant(Color.appOrange), gradientColor: .constant(Color.red), imageSet: .constant(randomStringImg()))
                    }
                    Spacer()
                }
                .padding(.horizontal, 25)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            validPhasesOfUser()
        }
    }
    
    func validPhasesOfUser(){
        let fetchDescriptor = FetchDescriptor<Phases>()
        var phases: [Phases] = []
        do {
            phases = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Fetch failed")
        }
        
        if let userPhase = phases.first(where: { $0.userId == userSettings.currentUser?.id }) {
            phasesOfUser = userPhase
        }
    }
}

struct CardView: View {
    @Binding var difficult: Difficult
    @Binding var status: String
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
                            .frame(width: 100, height: 100)
                            .offset(x: 170, y: -30)
                        
                        switch status {
                        case PhaseStatus.open.rawValue:
                            Image(systemName: "play.fill")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 10)
                        case PhaseStatus.finished.rawValue:
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 8)
                        case PhaseStatus.block.rawValue:
                            Image(systemName: "lock.fill")
                                .foregroundStyle(Color.white)
                                .padding(.leading, 9)
                        default:
                            Text("Some Error")
                        }
                    }.padding(.top, 30)
                    
                    Text(difficult.rawValue)
                        .font(.system(size: 18, design: .rounded))
                        .foregroundStyle(Color.appWhite)
                    
                    Text(status)
                        .font(.system(size: 30, design: .rounded))
                        .bold()
                        .foregroundStyle(Color.appWhite)
                    
                }.padding(.leading, 25)
            }
        }
        .disabled(status == PhaseStatus.block.rawValue)
        .opacity(status == PhaseStatus.block.rawValue ? 0.5 : 1.0)
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
                
                Spacer()
                
                Image(systemName: "trophy.fill")
                    .font(.system(size: 25))
                    .foregroundStyle(.appOrange)
                    .padding()
                    .onTapGesture {
                        isLeaderboardViewActive = true
                    }
                    .navigationDestination(isPresented: $isLeaderboardViewActive) {
                        LeaderboardView()
                    }
                
                Image(systemName: "person.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.appOrange)
                    .onTapGesture {
                        isUserViewActive = true
                    }
                    .navigationDestination(isPresented: $isUserViewActive) {
                        UserView()
                    }
                
            }.padding(.horizontal, 10)
        }
    }
}
