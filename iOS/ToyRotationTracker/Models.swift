import Foundation

struct Toy: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var toyName: String
    var status: String
    var date: Date = Date()
}
