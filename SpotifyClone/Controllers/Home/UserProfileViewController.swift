import UIKit

class UserProfileViewController: UIViewController {
    private var loading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()

        APIService.shared.fetch(url: "/me", model: UserProfile.self) { result in
            self.logger.info("\(result)")
        } withError: { error in
            self.logger.error("\(error)")
            DispatchQueue.main.async { self.updateFailedUI() }
        }
    }

    private func initializeUI() {
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        title = "Profile"
    }

    private func updateProfileUI() {
        let tableView = {
            let tableView = UITableView()
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            return tableView
        }()

        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    private func updateFailedUI() {
        let label = {
            let label = UILabel(frame: .zero)
            label.text = "Failed to load profile."
            label.sizeToFit()
            label.textColor = .secondaryLabel
            return label
        }()

        view.addSubview(label)
        label.center = view.center
    }
}

extension UserProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.contentConfiguration = {
            var content = cell.defaultContentConfiguration()
            content.text = "Foo"
            return content
        }()
        return cell
    }
}

extension UserProfileViewController: UITableViewDelegate {}
