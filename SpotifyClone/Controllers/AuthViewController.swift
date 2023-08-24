import UIKit
import WebKit

class AuthViewController: UIViewController {
    var onAuthenticated: ((Bool) -> Void)?
    
    private let logger = ConsoleLogger()

    private lazy var webView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        return WKWebView(frame: .zero, configuration: config)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }

    private func initializeUI() {
        title = "Sign In"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)

        webView.frame = view.bounds
        webView.navigationDelegate = self
        webView.load(URLRequest(url: AuthService.shared.url))

        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            guard let url = webView.url,
                  let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else { return }

            if let error = urlComponents.queryItems?.first(where: { $0.name == "error" })?.value {
                navigationController?.popViewController(animated: true)
                return logger.error(error)
            }

            if let code = urlComponents.queryItems?.first(where: { $0.name == "code" })?.value {
                webView.removeFromSuperview()
                navigationController?.popViewController(animated: true)
                Task {
                    do {
                        try await AuthService.shared.initializeTokens(code: code)
                        onAuthenticated?(true)
                    } catch {
                        logger.error(error.localizedDescription)
                        onAuthenticated?(false)
                    }
                }
            }
        }
    }
}

extension AuthViewController: WKNavigationDelegate {}
