import UIKit

final class HomeViewController: UIViewController {
    private enum Section: String {
        case newReleases = "New Releases"
        case featuredPlaylists = "Featured Playlists"
        case recommendedTracks = "Recommended Tracks"
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = GroupedCollectionView()
        collectionView.append(section: .init(
            vertical: .init(count: 3, width: .fractionalWidth(1.0), height: .absolute(360)),
            horizontal: .init(count: 1, width: .fractionalWidth(0.9), height: .absolute(360)),
            behavior: .groupPaging
        ))
        collectionView.append(section: .init(
            item: .init(width: .absolute(150), height: .absolute(150)),
            vertical: .init(count: 2, width: .absolute(150), height: .absolute(300)),
            horizontal: .init(count: 1, width: .absolute(150), height: .absolute(300)),
            behavior: .continuous
        ))
        collectionView.append(section: .init(
            vertical: .init(count: 5, width: .fractionalWidth(1.0), height: .absolute(360)),
            horizontal: .init(count: 1, width: .fractionalWidth(1.0), height: .absolute(360)),
            behavior: .groupPaging
        ))
        collectionView.contentInsets = .init(top: 2, leading: 2, bottom: 2, trailing: 2)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = self.view.bounds
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()

    private lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }

    private func initializeUI() {
        view.backgroundColor = .systemBackground
        title = "Home"

        navigationItem.rightBarButtonItem = .init(
            image: .init(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(settingButtonTapped)
        )

        view.addSubview(collectionView)
        view.addSubview(spinner)
    }

    @objc private func settingButtonTapped() {
        let vc = SettingViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 3 }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 8 }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemGreen
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegate {}
