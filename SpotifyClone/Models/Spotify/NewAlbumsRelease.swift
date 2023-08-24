import Foundation

struct NewAlbumsRelease {
    let albums: API.Page<Album>
}

extension NewAlbumsRelease: Codable {}
