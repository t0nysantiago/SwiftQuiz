//
//  Helpers.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 06/01/24.
//

import Foundation
import CryptoKit

func isValidEmail(email: String) -> Bool {
    let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    
    let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: email)
}

func verifyIfUsernameOrEmailExists(usersFetched: [User], username: String, email: String) -> Bool {
    let fetchedUsers = usersFetched
    var usernameExists: Bool = false
    var emailExists: Bool = false

    if username.isEmpty != true {
        usernameExists = fetchedUsers.contains { fetchedUser in
            return fetchedUser.username == username
        }
    }

    if email.isEmpty != true {
        emailExists = fetchedUsers.contains { fetchedUser in
            return fetchedUser.email == email
        }
    }

    return usernameExists || emailExists
}

func passwordIsValid(password: String) -> Bool {
    if password.count < 8 {
        return false
    }
    return true
}

func passwordsMatch(password: String, confirmPassword: String) -> Bool {

    if password.isEmpty || confirmPassword.isEmpty {
        return false
    }
    
    return password == confirmPassword
}

func hashPassword(password: String) -> String {
    let inputData = Data(password.utf8)
    let hashed = SHA256.hash(data: inputData)
    let passwordHashed: String = hashed.compactMap { String(format: "%02x", $0) }.joined()
    
    return passwordHashed
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
        return "At this stage you will have 20 questions on general topics, each worth 5 points if you get it right. To move on to the next one you will need to obtain 200 points and to achieve the difficulty completed status you will need to get all the questions correct."
    case .medium:
        return "At this stage you will have 30 questions on general topics, each worth 15 points if you get it right. To move on to the next one you will need to obtain 1500 points and to achieve the difficulty completed status you will need to get all the questions correct."
    case .hard:
        return "At this stage you will have 50 questions on general topics, each worth 50 points if you get it right. To achieve the difficulty completed status you will need to get all the questions correct."
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

func randomStringImg1() -> String {
    let arrayInterno = ["img6", "img7"]
    
    let indiceAleatorio = Int(arc4random_uniform(UInt32(arrayInterno.count)))
    return arrayInterno[indiceAleatorio]
}

func randomStringImg2() -> String {
    let arrayInterno = ["img2", "img3", "img8", "img9", "img11"]
    
    let indiceAleatorio = Int(arc4random_uniform(UInt32(arrayInterno.count)))
    return arrayInterno[indiceAleatorio]
}


func randomStringImg3() -> String {
    let arrayInterno = ["img1", "img4", "img5", "img10"]
    
    let indiceAleatorio = Int(arc4random_uniform(UInt32(arrayInterno.count)))
    return arrayInterno[indiceAleatorio]
}

