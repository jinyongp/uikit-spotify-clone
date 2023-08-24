import UIKit

class UserProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeUI()
    }

    private func initializeUI() {
        view.backgroundColor = .systemBackground
        title = "Profile"

        Task {
            try await print(APIService.shared.userProfile)
        }
    }
}
