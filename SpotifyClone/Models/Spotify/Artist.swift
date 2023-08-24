import Foundation

struct Artist {
    let id: String
    let name: String
    let type: String
    let urls: API.URLs
}

extension Artist: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case urls = "external_urls"
    }
}

// {
//  "external_urls": {
//    "spotify": "string"
//  },
//  "followers": {
//    "href": "string",
//    "total": 0
//  },
//  "genres": [
//    "Prog rock",
//    "Grunge"
//  ],
//  "href": "string",
//  "id": "string",
//  "images": [
//    {
//      "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
//      "height": 300,
//      "width": 300
//    }
//  ],
//  "name": "string",
//  "popularity": 0,
//  "type": "artist",
//  "uri": "string"
// }
