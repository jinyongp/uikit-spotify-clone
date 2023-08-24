import Foundation

struct API {
    struct Image: Codable {
        let url: String
//        let width: Int // TODO: Nullable
//        let height: Int // TODO: Nullable
    }

    typealias URLs = [String: String]
    
    struct Page<Item: Codable>: Codable {
        let items: [Item]
    }
}
