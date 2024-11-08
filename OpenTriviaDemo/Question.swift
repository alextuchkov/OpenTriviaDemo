//
//  Question.swift
//  OpenTriviaDemo
//
//  Created by Oleksandr Tuchkov on 08.11.2024.
//

import SwiftUI

struct Response: Decodable {
    let responseCode: Int
    let results: [Question]
    
    enum CodingKeys: String, CodingKey {
        case responseCode = "response_code"
        case results
    }
}


struct Question: Decodable, Identifiable {
    var id = UUID() // Makes it conform to Identifiable
    let type: String
    let difficulty: String
    let category: String
    let question: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    var decodedQuestion: String {
            question.decodeHTMLEntities()
        }
    
    enum CodingKeys: String, CodingKey {
        case type
        case difficulty
        case category
        case question
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}


extension String {
    func decodeHTMLEntities() -> String {
        var decoded = self
        let entities = [
            "&quot;": "\"",
            "&amp;": "&",
            "&#039;": "'",
            "&lt;": "<",
            "&gt;": ">",
            "&deg;C": "°C",
            "&deg;F": "°F",
            "arsquo;": "'",
            "&eacute;": "é"
            
            
        ]
        entities.forEach { decoded = decoded.replacingOccurrences(of: $0.key, with: $0.value) }
        return decoded
    }
}
    
    enum Difficulty: String, Codable {
        case easy
        case medium
        case hard
    }
    
    enum Category: String, Codable {
        case sports = "21"
        case art = "Art"
        case history = "History"
    }
    

