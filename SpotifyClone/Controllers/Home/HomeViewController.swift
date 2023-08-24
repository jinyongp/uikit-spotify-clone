import UIKit

final class HomeViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }

    private func initializeUI() {
        view.backgroundColor = .systemBackground
        title = "Home"

        navigationItem.rightBarButtonItem = .init(image: .init(systemName: "gear"), style: .done, target: self, action: #selector(settingButtonTapped))
    }

    @objc private func settingButtonTapped() {
        let vc = UserProfileViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
