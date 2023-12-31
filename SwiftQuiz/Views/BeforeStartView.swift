//
//  BeforeStartView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 27/12/23.
//

import SwiftUI

struct BeforeStartView: View {
    @State private var triviaQuestions: [TriviaQuestion] = []
    @State private var isQuizViewActive = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var backgroundColorChoosed: Color
    @Binding var logoImage: String
    @Binding var difficult: Difficult
    var body: some View {
        NavigationView {
            ZStack (alignment: .leading) {
                backgroundColorChoosed.ignoresSafeArea()
                
                VStack (alignment: .leading){
                    
                    Image(systemName: "chevron.backward.circle")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.appWhite)
                        .onTapGesture {
                            presentationMode.wrappedValue.dismiss()
                        }
                    
                    Spacer()
                    HStack{
                        Spacer()
                        Image(logoImage)
                            .resizable()
                            .frame(width: 300, height: 250)
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
                    
                    NavigationLink(
                        destination: QuizView(triviaQuestions: $triviaQuestions, difficult: .constant(difficult), backgroundColorChoosed: .constant(backgroundColorChoosed)),
                        isActive: $isQuizViewActive,
                        label: {
                            EmptyView()
                        }
                    )
                    
                    Button(action: {
                        print("entrouuuuu")
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
        return "In this phase you will have 20 questions on general topics and to move on to the next phase you will need to get 10 questions correct."
    case .medium:
        return "In this phase you will have 30 questions on general topics and to move on to the next phase you will need to get 20 questions correct."
    case .hard:
        return "In this phase you will have 50 questions on general topics and to complete this phase you will need to get 45 questions correct."
    }
}

#Preview {
    BeforeStartView(backgroundColorChoosed: .constant(Color.blue), logoImage: .constant("history"), difficult: .constant(Difficult.easy))
}
