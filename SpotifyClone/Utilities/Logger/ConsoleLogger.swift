import Foundation

struct ConsoleLogger: Logger {
    static let shared = ConsoleLogger()
    private init() {}
    
    func info(_ string: String) {
        print("[\(_typename).Info] \(string)")
    }

    func warn(_ string: String) {
        print("[\(_typename).Warn] \(string)")
    }

    func error(_ string: String) {
        print("[\(_typename).Error] \(string)")
    }
}
