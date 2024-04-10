//
//  CommentViewController.swift
//  Snaptime
//
//  Created by 이대현 on 4/2/24.
//

import UIKit

final class CommentViewController: BaseViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글"
        return label
    }()
    
    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "dddddd")
        return view
    }()
    
    private lazy var commentColelctionView: UICollectionView = {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: {(
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
            ) -> NSCollectionLayoutSection? in
                // 대댓글 item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(40)
                    )
                )
                
                // 대댓글 item의 그룹
                let containerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(1)),
                    subitems: [item])
                containerGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0)
                
                // 그룹을 section에 추가
                let section = NSCollectionLayoutSection(group: containerGroup)
                
                // header 설정
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(10)
                    ),
                    elementKind: "header",
                    alignment: .top
                )
                
                // footer 설정
                let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(40)
                    ),
                    elementKind: "footer",
                    alignment: .bottom)
                sectionFooter.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0)
                
                // section에 header와 footer 추가
                section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
                
                return section
            }, configuration: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSource()
    }
    
    // MARK: -- Setup CollectionView
    
    // collectionView dataSource
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CommentCollectionViewCell, Int> {
            (cell, indexPath, identifier) in
            // cell.nickName.text = "haha"
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Int>(
            collectionView: commentColelctionView, 
            cellProvider: ({(
                collectionView: UICollectionView,
                indexPath: IndexPath,
                identifier: Int
            ) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration, 
                    for: indexPath,
                    item: identifier)
            })
        )
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<CommentSupplementaryHeaderView>(elementKind: "header") { supplementaryView, elementKind, indexPath in
            // header 세팅
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<CommentSupplementaryFooterView>(elementKind: "footer") { supplementaryView, elementKind, indexPath in
            // footer 세팅
        }
        
        dataSource.supplementaryViewProvider = {(view, kind, index) in
            if kind == "header" {
                return self.commentColelctionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            } else {
                print(kind)
                return self.commentColelctionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: index)
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        
        var identifierOffset = 0 // 아이템의 identifier
        let itemPerSection = 3
        
        for idx in 0...10 {
            snapshot.appendSections([idx])
            
            let maxIdentifier = identifierOffset + itemPerSection
            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
            identifierOffset += itemPerSection
        }
        
        dataSource.apply(snapshot)
    }
    
    
    
    // MARK: -- Setup UI
    override func setupLayouts() {
        self.view.backgroundColor = .systemBackground
        
        [
            titleLabel,
            separatorView,
            commentColelctionView
        ].forEach {
            self.view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(30)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        commentColelctionView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
