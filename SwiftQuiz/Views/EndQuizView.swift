//
//  EndQuizView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 30/12/23.
//

import SwiftUI
import SwiftData
import ConfettiSwiftUI

struct EndQuizView: View {
    @State private var phasesOfUser: Phases?
    @State private var showAlertError: Bool = false
    @State private var isToBackHome: Bool = false
    @Binding var finalPoints: Int
    @Binding var backgroundColorChoosed: Color
    @Binding var difficult: Difficult
    @Binding var countCorrectAnswer: Int
    @Environment (\.modelContext) var modelContext
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundColorChoosed.ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    ImageToShowEndQuizView()
                    
                    Text("Congratulations!")
                        .font(.system(size: 30, design: .rounded))
                        .bold()
                        .foregroundStyle(.appWhite)
                    Text("You got \(finalPoints) points")
                        .font(.system(size: 20, design: .rounded))
                        .foregroundStyle(.appWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        if let user = userSettings.currentUser {
                            let newPoints = Points(userId: user.id, point: finalPoints)
                            modelContext.insert(newPoints)
                            print(phasesOfUser!)
                            if let userPhase = phasesOfUser {
                                unlockPhases(userPhase: userPhase)
                            }
                            isToBackHome = true
                        } else {
                            showAlertError = true
                        }
                    }, label: {
                        Text("Done")
                            .font(.system(size: 20, design: .rounded))
                            .foregroundStyle(backgroundColorChoosed)
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 15.0)
                                    .fill(.appWhite)
                            )
                    })
                    .padding(.horizontal, 40)
                    .alert("Erro inesperado", isPresented: $showAlertError) {
                        Button("OK", role: .cancel) { showAlertError = false }
                    }
                    .navigationDestination(isPresented: $isToBackHome) {
                        HomeView()
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            validPhasesOfUser()
        }
    }
    
    func returnUserPoints() -> Int {
        let fetchDescriptor = FetchDescriptor<Points>()
        var countPoints = 0
        var points: [Points] = []
        do {
            points = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Fetch failed")
        }
        
        for point in points {
            if point.userId == userSettings.currentUser?.id {
                countPoints += point.point
            }
        }
        
        return countPoints
    }
    
    func validPhasesOfUser() {
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
    
    func fetchData() -> [Phases] {
        let fetchDescriptor = FetchDescriptor<Phases>()
        var phases: [Phases] = []
        do {
            phases = try modelContext.fetch(fetchDescriptor)
        } catch {
            print("Fetch failed")
        }
        return phases
    }
    
    func updatePhases(userPhase: Phases) {
        let fetchedPhases = fetchData()
        if let userPhaseFound = fetchedPhases.first(where: { $0.userId == userSettings.currentUser?.id }) {
            userPhaseFound.easy = userPhase.easy
            userPhaseFound.medium = userPhase.medium
            userPhaseFound.hard = userPhase.hard
        }
    }
    
    func unlockPhases(userPhase: Phases) {
        let userPoints = returnUserPoints()
        
        if userPhase.easy == PhaseStatus.open.rawValue && userPoints >= 200 {
            userPhase.medium = PhaseStatus.open.rawValue
        } else if userPhase.medium == PhaseStatus.open.rawValue && userPoints >= 1500 {
            userPhase.hard = PhaseStatus.open.rawValue
        }
        
        if userPhase.easy == PhaseStatus.open.rawValue && countCorrectAnswer == questionsByDifficulty(for: difficult) {
            userPhase.easy = PhaseStatus.finished.rawValue
        } else if userPhase.medium == PhaseStatus.open.rawValue && countCorrectAnswer == questionsByDifficulty(for: difficult) {
            userPhase.medium = PhaseStatus.finished.rawValue
        } else if userPhase.hard == PhaseStatus.open.rawValue && countCorrectAnswer == questionsByDifficulty(for: difficult) {
            userPhase.hard = PhaseStatus.finished.rawValue
        }
        
        updatePhases(userPhase: userPhase)
    }
}

struct ImageToShowEndQuizView: View {
    @State private var yOffset: CGFloat = 0
    @State private var counter = 0
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [.white, .clear]), center: .center, startRadius: 0, endRadius: 180)
                .frame(width: 400, height: 400)
            
            Image("giftBox")
                .resizable()
                .frame(width: 200, height: 200)
                .offset(y: yOffset)
                .onAppear {
                    animate()
                    counter += 1
                }
                .onTapGesture {
                    counter += 1
                }
                .confettiCannon(counter: $counter, num: 10)
        }
    }
    
    func animate() {
        withAnimation(Animation.easeInOut(duration: 0.5)) {
            self.yOffset = -20
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                self.yOffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.animate()
            }
        }
    }
}
