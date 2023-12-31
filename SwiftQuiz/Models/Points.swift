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
    
    var userId: String
    
    var point: Int
    
    var date: Date

    init(userId: String,
         point: Int
         ) {
        self.userId = userId
        self.point = point
        self.date = .now
    }
}
