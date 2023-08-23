import UIKit

final class WelcomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }

    private func initializeUI() {
        title = "Spotify"
        view.backgroundColor = .systemGreen

        let signInButton = {
            let button = UIButton()
            button.backgroundColor = .systemBackground
            button.setTitle("Sign In with Spotify", for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 16)
            button.layer.cornerRadius = 10.0
            button.layer.masksToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()

        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        view.addSubview(signInButton)

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
            signInButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    @objc
    private func signInButtonTapped() {
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.onAuthenticated = { [weak self] success in
            if success {
                let tabBarController = TabBarViewController()
                self?.navigationController?.setViewControllers([tabBarController], animated: true)
            } else {
                let alert = UIAlertController(title: "ERROR", message: "Sign In Failed.\nPlease contact your administrator.", preferredStyle: .alert)
                alert.addAction(.init(title: "Back", style: .cancel))
                self?.present(alert, animated: true)
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
