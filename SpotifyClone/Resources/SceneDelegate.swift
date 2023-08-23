import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()

        Task {
            #if DEBUG
            let defaults = UserDefaults.standard
            let dictionary = defaults.dictionaryRepresentation()
            dictionary.keys.forEach { defaults.removeObject(forKey: $0) }
            #endif
            if await AuthService.shared.isAuthenticated() {
                window?.rootViewController = TabBarViewController()
            } else {
                let nav = UINavigationController(rootViewController: WelcomeViewController())
                nav.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
                nav.navigationBar.prefersLargeTitles = true
                window?.rootViewController = nav
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
