import Foundation

struct Album: Decodable, Equatable {
    var id: Int
    var userId: Int
    var title: String
}
