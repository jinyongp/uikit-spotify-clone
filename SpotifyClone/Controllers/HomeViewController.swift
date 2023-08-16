import UIKit

final class HomeViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }

    private func initializeUI() {
        view.backgroundColor = .systemBackground
    }
}
