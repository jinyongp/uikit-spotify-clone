import UIKit

final class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }

    private func initializeUI() {
        title = "Spotify"
        view.backgroundColor = .systemGreen
    }
}
