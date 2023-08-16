import UIKit

final class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
        setupTabBar()
    }

    private func initializeUI() {
        view.backgroundColor = .systemBackground
    }

    private func setupTabBar() {
        let tabs: [(root: UIViewController, title: String, icon: String)] = [
            (HomeViewController(), "Browse", "house"),
            (SearchViewController(), "Search", "magnifyingglass"),
            (LibraryViewController(), "Library", "music.note.list"),
        ]

        setViewControllers(tabs.map { root, title, icon in
            root.title = title
            root.navigationItem.largeTitleDisplayMode = .always
            let nav = UINavigationController(rootViewController: root)
            nav.tabBarItem = UITabBarItem(title: title, image: .init(systemName: icon), tag: 1)
            nav.navigationBar.prefersLargeTitles = true
            return nav
        }, animated: false)
    }
}
