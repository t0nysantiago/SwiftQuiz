//
//  Phases.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 05/01/24.
//

import Foundation
import SwiftData

@Model
final public class Phases {
    
    @Attribute(.unique) var userId: String
    
    var easy: String
    
    var medium: String
    
    var hard: String

    init(userId: String
         ) {
        self.userId = userId
        self.easy = PhaseStatus.open.rawValue
        self.medium = PhaseStatus.block.rawValue
        self.hard = PhaseStatus.block.rawValue
    }
}

enum PhaseStatus: String, CaseIterable, Identifiable {
    case open = "Continue", finished = "Finished", block = "Blocked"
    var id: Self { self }
}

enum Difficult: String, CaseIterable, Identifiable {
    case easy = "Easy", medium = "Medium", hard = "Hard"
    var id: Self { self }
}
