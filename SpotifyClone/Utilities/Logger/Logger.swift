import Foundation

protocol Logger {
    func info(_ string: String)
    func warn(_ string: String)
    func error(_ string: String)
}

extension Logger {
    static var _typename: String { String(describing: Self.self) }
    var _typename: String { Self._typename }
}
