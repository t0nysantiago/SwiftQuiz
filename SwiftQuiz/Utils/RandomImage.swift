//
//  RandomImage.swift
//  SwiftQuiz
//
//  Created by Tony Santiago on 05/01/24.
//

import Foundation

func randomStringImg() -> String {
    let arrayInterno = ["img1", "img2", "img3", "img4", "img5", "img6", "img7", "img8", "img9", "img10", "img11"]
    
    let indiceAleatorio = Int(arc4random_uniform(UInt32(arrayInterno.count)))
    return arrayInterno[indiceAleatorio]
}
