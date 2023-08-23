import UIKit
import WebKit

class AuthViewController: UIViewController, Debugger {
    var onAuthenticated: ((Bool) -> Void)?

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
                  let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let code = urlComponents.queryItems?.first(where: { $0.name == "code" })?.value
            else { return }
            webView.isHidden = true
            Task {
                navigationController?.popViewController(animated: true)
                do {
                    try await AuthService.shared.initializeTokens(code: code)
                    onAuthenticated?(true)
                } catch {
                    printError(error.localizedDescription)
                    onAuthenticated?(false)
                }
            }
        }
    }
}

extension AuthViewController: WKNavigationDelegate {}
