//
//  BeforeStartView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI

struct BeforeStartView: View {
    @State private var backToHome: Bool = false
    @State private var triviaQuestions: [TriviaQuestion] = []
    @State private var isQuizViewActive = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var backgroundColorChoosed: Color
    @Binding var logoImage: String
    @Binding var difficult: Difficult
    var body: some View {
        NavigationStack {
            ZStack (alignment: .leading) {
                backgroundColorChoosed.ignoresSafeArea()
                
                VStack (alignment: .leading){
                    
                    Image(systemName: "chevron.backward.circle")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.appWhite)
                        .onTapGesture {
                            backToHome = true
                        }
                        .navigationDestination(isPresented: $backToHome) {
                            HomeView()
                        }
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Image(logoImage)
                            .resizable()
                            .frame(width: 280, height: 280)
                        Spacer()
                    }
                    Spacer()
                    
                    Text(difficultyTitle(for: difficult))
                        .font(.system(size: 18, design: .rounded))
                        .bold()
                        .foregroundColor(.white)
                    Text(difficult.rawValue)
                        .font(.system(size: 25, design: .rounded))
                        .bold()
                        .foregroundStyle(Color.appWhite)
                    Text(difficultyDescription(for: difficult))
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.top, 1)
                    
                    Spacer()
                    
                    Button(action: {
                        isQuizViewActive = true
                    }) {
                        ZStack{
                            Text("Play")
                                .foregroundColor(backgroundColorChoosed)
                                .font(.system(size: 18, design: .rounded))
                                .bold()
                                .cornerRadius(15)
                        }
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 15.0))
                        .foregroundStyle(Color.appWhite)
                    }
                    .navigationDestination(isPresented: $isQuizViewActive) {
                        QuizView(triviaQuestions: $triviaQuestions, difficult: .constant(difficult), logoImage: $logoImage, backgroundColorChoosed: .constant(backgroundColorChoosed))
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 20)
            }
            .onAppear {
                let triviaModel = TriviaModel()
                triviaModel.fetchTriviaQuestions(amount: questionsByDifficulty(for: difficult), difficult: difficult) { questions in
                    if let questions = questions {
                        DispatchQueue.main.async {
                            self.triviaQuestions = questions
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

func difficultyTitle(for difficulty: Difficult) -> String {
    switch difficulty {
    case .easy:
        return "Level one"
    case .medium:
        return "Level two"
    case .hard:
        return "Level three"
    }
}

func questionsByDifficulty(for difficult: Difficult) -> Int {
    switch difficult {
    case .easy:
        return 20
    case .medium:
        return 30
    case .hard:
        return 50
    }
}
    
func difficultyDescription(for difficulty: Difficult) -> String {
    switch difficulty {
    case .easy:
        return "At this stage you will have 20 questions on general topics, each worth 10 points if you get it right and if you get it wrong you will lose 5 points. To move on to the next one you will need to obtain 200 points and to achieve the difficulty completed status you will need to get all the questions correct."
    case .medium:
        return "At this stage you will have 30 questions on general topics, each worth 50 points if you get it right and if you get it wrong you will lose 30 points. To move on to the next one you will need to obtain 1500 points and to achieve the difficulty completed status you will need to get all the questions correct."
    case .hard:
        return "At this stage you will have 50 questions on general topics, each worth 300 points if you get it right and if you get it wrong you will lose 100 points. To achieve the difficulty completed status you will need to get all the questions correct."
    }
}
