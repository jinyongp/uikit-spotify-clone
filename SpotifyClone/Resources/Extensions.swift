import Foundation

extension String {
    static func random(length: Int, numeric: Bool = false) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ\(numeric ? "0123456789" : "")"
        return String((0 ..< length).map { _ in letters.randomElement()! })
    }
}

extension URL {
    typealias Query = (name: String, value: String)

    mutating func append(query: Query) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(URLQueryItem(name: query.name, value: query.value))
        urlComponents.queryItems = queryItems
        self = urlComponents.url!
    }

    mutating func append(queries: [Query]) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        var queryItems = urlComponents.queryItems ?? []
        queries.forEach { queryItems.append(URLQueryItem(name: $0.name, value: $0.value)) }
        urlComponents.queryItems = queryItems
        self = urlComponents.url!
    }

    init?(string: String, queries: [Query]) {
        self.init(string: string)
        append(queries: queries)
    }
}
