import UIKit

class SettingViewController: UIViewController {
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = self.view.bounds
        return tableView
    }()

    private lazy var sections: [Setting.Section] = [
        .init(title: "Profile", options: [
            .init(title: "View Your Profile", handler: { [weak self] in
                guard let weakSelf = self else { return }
                let vc = UserProfileViewController()
                weakSelf.navigationController?.pushViewController(vc, animated: true)
            }),
        ]),
        .init(title: "Account", options: [
            .init(title: "View Your Profile", handler: { [weak self] in
                
            }),
        ]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }

    private func initializeUI() {
        view.backgroundColor = .systemBackground
        title = "Setting"

        view.addSubview(tableView)
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].options.count }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let option = sections[indexPath.section].options[indexPath.row]

        cell.contentConfiguration = {
            var content = cell.defaultContentConfiguration()
            content.text = option.title
            return content
        }()

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let option = sections[indexPath.section].options[indexPath.row]
        option.handler()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = sections[section]
        return section.title
    }
}

extension SettingViewController: UITableViewDelegate {}
