import Foundation

struct Owner {
    let id: String
    let name: String
    let urls: API.URLs
}

extension Owner: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name = "display_name"
        case urls = "external_urls"
    }
}

//{
//  "external_urls": {
//    "spotify": "string"
//  },
//  "followers": {
//    "href": "string",
//    "total": 0
//  },
//  "href": "string",
//  "id": "string",
//  "type": "user",
//  "uri": "string",
//  "display_name": "string"
//},
