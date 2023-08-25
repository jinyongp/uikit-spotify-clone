import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        setupTabBar()

        AuthService.shared.startRefreshAccessToken()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let frame = tabBar.frame
        let paddingTop: CGFloat = 5.0
        tabBar.frame = .init(
            x: frame.origin.x,
            y: frame.origin.y - paddingTop,
            width: frame.width,
            height: frame.height + paddingTop
        )
    }

    private func initializeUI() {
        tabBar.backgroundColor = .systemBackground.withAlphaComponent(0.5)
    }

    private func setupTabBar() {
        let tabs: [(root: UIViewController, title: String, icon: String)] = [
            (HomeViewController(), "Browse", "house"),
            (SearchViewController(), "Search", "magnifyingglass"),
            (LibraryViewController(), "Library", "music.note.list"),
        ]

        setViewControllers(tabs.map { root, title, icon in
            root.title = title
            root.navigationItem.largeTitleDisplayMode = .automatic
            let controller = UINavigationController(rootViewController: root)
            controller.tabBarItem = UITabBarItem(title: title, image: .init(systemName: icon), tag: 1)
            controller.navigationBar.prefersLargeTitles = true
            controller.navigationBar.tintColor = .label
            return controller
        }, animated: false)
    }
}
