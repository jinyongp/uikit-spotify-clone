import Foundation

struct Setting {
    struct Section {
        let title: String
        let options: [Option]
    }

    struct Option {
        let title: String
        let handler: () -> Void
    }
}
