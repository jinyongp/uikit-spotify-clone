import Foundation

protocol Debugger {}

private enum LogType<T: Debugger>: String {
    case info = "Info"
    case warn = "Warn"
    case error = "Error"

    var prefix: String { "[\(T._type).\(rawValue)]" }
}

extension Debugger {
    static var _type: String { String(describing: Self.self) }
    var _type: String { Self._type }

    func printInfo(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        _print(items, type: .info, separator: separator, terminator: terminator)
    }

    func printWarn(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        _print(items, type: .warn, separator: separator, terminator: terminator)
    }

    func printError(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        _print(items, type: .error, separator: separator, terminator: terminator)
    }

    private func _print(_ items: Any..., type: LogType<Self> = .info, separator: String = " ", terminator: String = "\n") {
        print(type.prefix, terminator: " ")
        print(items, separator: separator, terminator: terminator)
    }
}
