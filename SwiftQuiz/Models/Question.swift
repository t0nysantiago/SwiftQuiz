//
//  Question.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 30/12/23.
//

import Foundation

struct TriviaResponse: Codable {
    let responseCode: Int
    let results: [TriviaQuestion]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}

struct TriviaQuestion: Codable {
    let type: String
    let difficulty: String
    let category: String
    var question: String
    var correctAnswer: String
    var incorrectAnswers: [String]
    
    enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

class TriviaModel: ObservableObject {
    func fetchTriviaQuestions(amount: Int, difficult: Difficult, completion: @escaping ([TriviaQuestion]?) -> Void) {
        guard let url = URL(string: "https://opentdb.com/api.php?amount=\(amount)&difficulty=\(difficult.rawValue.lowercased())&type=multiple&encode=base64") else {
            print("URL inválida")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Erro: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Dados ausentes")
                completion(nil)
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TriviaResponse.self, from: data)
                
                var decodedQuestions: [TriviaQuestion] = []
                for question in decodedResponse.results {
                    var decodedQuestion = question
                    if let decodedText = Data(base64Encoded: question.question)?.string {
                        decodedQuestion.question = decodedText
                    }
                    if let decodedCorrectAnswer = Data(base64Encoded: question.correctAnswer)?.string {
                        decodedQuestion.correctAnswer = decodedCorrectAnswer
                    }
                    let decodedIncorrectAnswers = question.incorrectAnswers.map { Data(base64Encoded: $0)?.string ?? $0 }
                    decodedQuestion.incorrectAnswers = decodedIncorrectAnswers
                    decodedQuestions.append(decodedQuestion)
                }
                
                completion(decodedQuestions)
                
            } catch {
                print("Erro na decodificação: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}

extension Data {
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
}
