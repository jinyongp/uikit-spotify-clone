import UIKit

final class LibraryViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }

    private func initializeUI() {
        view.backgroundColor = .systemBackground
    }
}
