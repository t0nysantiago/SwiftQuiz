//
//  TesteFetchView.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 30/12/23.
//

import SwiftUI

struct TesteFetchView: View {
    @ObservedObject var triviaModel = TriviaModel()
    
    var body: some View {
        NavigationView {
            List(triviaModel.triviaQuestions, id: \.question) { question in
                VStack(alignment: .leading) {
                    Text("Pergunta:")
                        .font(.headline)
                    Text(question.question)
                        .font(.body)
                        .padding(.bottom, 5)
                    
                    Text("Resposta Correta:")
                        .font(.headline)
                    Text(question.correctAnswer)
                        .font(.body)
                        .padding(.bottom, 5)
                    
                    Text("Respostas Incorretas:")
                        .font(.headline)
                    ForEach(question.incorrectAnswers, id: \.self) { answer in
                        Text(answer)
                            .font(.body)
                    }
                }
            }
            .navigationBarTitle("Questões Decodificadas")
            .onAppear {
                triviaModel.fetchTriviaQuestions(amount: 20, difficult: Difficult.hard)
            }
        }
    }
}
#Preview {
    TesteFetchView()
}
