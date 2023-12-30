//
//  Points.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 28/12/23.
//

import Foundation
import SwiftData

@Model
final public class Points {
    
    @Relationship(deleteRule: .cascade, inverse: \User.points)
    weak var user: User?
    
    var point: Int
    
    var date: Date

    init(user: User,
         point: Int
         ) {
        self.user = user
        self.point = point
        self.date = .now
    }
}
