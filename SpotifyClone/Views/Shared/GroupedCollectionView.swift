import UIKit

final class GroupedCollectionView: UICollectionView {
    var contentInsets: NSDirectionalEdgeInsets?

    struct Item {
        let width: NSCollectionLayoutDimension
        let height: NSCollectionLayoutDimension
    }

    struct Group {
        let count: Int
        let width: NSCollectionLayoutDimension
        let height: NSCollectionLayoutDimension
    }

    struct Section {
        let item: Item
        let vertical: Group
        let horizontal: Group
        let behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior

        init(
            item: Item? = nil,
            vertical: Group? = nil,
            horizontal: Group? = nil,
            behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior? = nil
        ) {
            self.item = item ?? .init(width: .fractionalWidth(1.0), height: .fractionalWidth(1.0))
            self.vertical = vertical ?? .init(count: 1, width: .fractionalWidth(1.0), height: .absolute(100))
            self.horizontal = horizontal ?? .init(count: 1, width: .fractionalWidth(1.0), height: .absolute(100))
            self.behavior = behavior ?? .none
        }
    }

    private var sections: [Section] = []

    private lazy var layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
        guard let weakSelf = self else { return nil }
        return weakSelf.createSectionLayout(section: weakSelf.sections[section])
    }

    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionViewLayout = layout
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func append(section: Section) {
        sections.append(section)
    }

    private func createSectionLayout(section: Section) -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: section.item.width,
                heightDimension: section.item.height
            )
        )
        item.contentInsets = contentInsets ?? .zero
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: section.vertical.width,
                heightDimension: section.vertical.height
            ),
            subitem: item,
            count: section.vertical.count
        )
        let horizontalGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: section.horizontal.width,
                heightDimension: section.horizontal.height
            ),
            subitem: verticalGroup,
            count: section.horizontal.count
        )

        let layoutSection = NSCollectionLayoutSection(group: horizontalGroup)
        layoutSection.orthogonalScrollingBehavior = section.behavior
        return layoutSection
    }
}
