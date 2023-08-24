import Foundation

struct User {
    let id: String
    let name: String
    let email: String
    let urls: API.URLs
    let images: [API.Image]
}

extension User: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name = "display_name"
        case email
        case urls = "external_urls"
        case images
    }
}

//{
//  "country": "string",
//  "display_name": "string",
//  "email": "string",
//  "explicit_content": {
//    "filter_enabled": false,
//    "filter_locked": false
//  },
//  "external_urls": {
//    "spotify": "string"
//  },
//  "followers": {
//    "href": "string",
//    "total": 0
//  },
//  "href": "string",
//  "id": "string",
//  "images": [
//    {
//      "url": "https://i.scdn.co/image/ab67616d00001e02ff9ca10b55ce82ae553c8228",
//      "height": 300,
//      "width": 300
//    }
//  ],
//  "product": "string",
//  "type": "string",
//  "uri": "string"
//}
