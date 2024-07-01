//
//  CommentViewController.swift
//  Snaptime
//
//  Created by 이대현 on 4/2/24.
//

import UIKit

protocol CommentViewControllerDelegate: AnyObject {
    func presentCommentVC()
}

final class CommentViewController: BaseViewController {
    weak var delegate: CommentViewControllerDelegate?
    
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
    
    private lazy var separatorView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "dddddd")
        return view
    }()
    
    private lazy var separatorView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexCode: "dddddd")
        return view
    }()
    
    private lazy var commentCollectionView: UICollectionView = {
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
    
    private lazy var replyImageView: UIImageView = {
        let imageView = RoundImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var replyTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray5
        textField.placeholder = "Jocelyn에게 댓글달기"
        textField.font = .systemFont(ofSize: 12)
        textField.addLeftPadding(16)
        return textField
    }()
    
    private lazy var replySubmitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        button.tintColor = .snaptimeBlue
        return button
    }()
    
    private lazy var replyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
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
            collectionView: commentCollectionView, 
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
                return self.commentCollectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            } else {
                return self.commentCollectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: index)
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
            replyImageView,
            replyTextField,
            replySubmitButton
        ].forEach {
            replyStackView.addArrangedSubview($0)
        }
        [
            titleLabel,
            separatorView,
            separatorView2,
            separatorView3,
            commentCollectionView,
            replyStackView
        ].forEach {
            self.view.addSubview($0)
        }
        
        // setup UI
        
        replyTextField.layer.cornerRadius = 15
        replyTextField.clipsToBounds = true
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
        
        replyImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
        
        replyTextField.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        replySubmitButton.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        
        replyStackView.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(60)
        }
        
        separatorView2.snp.makeConstraints {
            $0.top.equalTo(replyStackView.snp.top)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        separatorView3.snp.makeConstraints {
            $0.top.equalTo(replyStackView.snp.bottom)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        commentCollectionView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(replyStackView.snp.top)
        }
    }
}
