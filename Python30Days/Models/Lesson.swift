import Foundation

struct Lesson: Codable, Identifiable {
    let id: Int
    let title: String
    let summary: String
    let content: String
    let question: String
    let options: [String]
    let correctAnswer: Int
}

struct QuoteResponse: Decodable {
    let quote: String
    let author: String
}
