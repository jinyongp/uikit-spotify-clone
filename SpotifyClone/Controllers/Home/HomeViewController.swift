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
        
        APIService.shared.fetch(url: "/recommendations/available-genre-seeds", model: GenreSeeds.self) { seed in
            APIService.shared.fetch(
                url: "/recommendations",
                model: Recommendations.self,
                query: [("seed_genres", seed.genres[0..<5].joined(separator: ","))]
            ) { result in
                print(result)
            } failure: { error in
                print(error)
            }
        } failure: { error in
            print(error)
        }
    }

    @objc private func settingButtonTapped() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
