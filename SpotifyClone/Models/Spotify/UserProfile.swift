import Foundation

struct UserProfile {
    var id: String
    var name: String
    var email: String
}

extension UserProfile: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case name = "display_name"
        case email
    }
}

//{
//    country = KR;
//    "display_name" = "Jinyong Park";
//    email = "dev.jinyongp@gmail.com";
//    "explicit_content" =     {
//        "filter_enabled" = 0;
//        "filter_locked" = 0;
//    };
//    "external_urls" =     {
//        spotify = "https://open.spotify.com/user/314lhijwqvmdqjutouw2zckhml7q";
//    };
//    followers =     {
//        href = "<null>";
//        total = 0;
//    };
//    href = "https://api.spotify.com/v1/users/314lhijwqvmdqjutouw2zckhml7q";
//    id = 314lhijwqvmdqjutouw2zckhml7q;
//    images =     (
//    );
//    product = free;
//    type = user;
//    uri = "spotify:user:314lhijwqvmdqjutouw2zckhml7q";
//}

