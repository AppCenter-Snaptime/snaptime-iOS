//
//  CommentViewController.swift
//  Snaptime
//
//  Created by 이대현 on 4/2/24.
//

import Alamofire
import UIKit
import Kingfisher


protocol CommentViewControllerDelegate: AnyObject {
    func presentCommentVC(snap: FindSnapResDto)
}

final class CommentViewController: BaseViewController {
    init(snapID: Int, userName snapUserName: String) {
        self.snapID = snapID
        self.snapUserName = snapUserName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupDataSource()
        self.fetchComment(pageNum: 1, snapId: self.snapID)
        
        guard let id = ProfileBasicUserDefaults().loginId else { return }
        
        self.fetchUserProfile(loginId: id)
        self.view.gestureRecognizers?.removeAll()
    }
    
    private let snapID: Int
    private let snapUserName: String
    private var parentComments: [ParentReplyInfo] = []
    private var childComments: [[ChildReplyInfo]?] = []
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
    
    private let inputContentView = UIView()
    
    private lazy var commentCollectionView: UICollectionView = {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: {(
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
            ) -> NSCollectionLayoutSection? in
                /*
                 원 댓글 : Header
                 답글 : item
                 답글 추가/가리기 : Footer
                 */
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
                        heightDimension: .estimated(20)),
                    subitems: [item])
                containerGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0)
                
                // 그룹을 section에 추가
                let section = NSCollectionLayoutSection(group: containerGroup)
                
                // header 설정
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(20)
                    ),
                    elementKind: "header",
                    alignment: .top
                )
                
                // footer 설정
                let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(10)
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
        imageView.backgroundColor = .snaptimeGray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var replyTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray5
        textField.placeholder = "\(self.snapUserName)에게 댓글달기"
        textField.font = .systemFont(ofSize: 12)
        textField.delegate = self
        textField.addLeftPadding(16)
        return textField
    }()
    
    private lazy var replySubmitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        button.tintColor = .snaptimeBlue
        button.addAction(UIAction { [weak self] _ in
            guard let self = self,
                  let comment = self.replyTextField.text else {
                return
            }
            let param = AddParentReplyReqDto(replyMessage: comment, snapId: self.snapID)
            print("post success")
            APIService.postReply.performRequest(
                with: param,
                responseType: CommonResDtoVoid.self
            ) { [weak self] _ in
                DispatchQueue.main.async {
                    guard let id = self?.snapID else { return }
                    self?.fetchComment(pageNum: 1, snapId: id)
                    self?.replyTextField.text = ""
                }
            }
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var replyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    // MARK: -- 댓글 목록 서버 통신
    private func fetchComment(pageNum: Int, snapId: Int) {
        APIService.fetchParentReply(
            pageNum: pageNum,
            snapId: snapId
        ).performRequest(responseType: CommonResponseDtoListFindParentReplyResDto.self) { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.parentComments = result.result.parentReplyInfoResDtos
                    self.applySnapShot(data: self.parentComments)
                    self.commentCollectionView.layoutIfNeeded()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchChildComments() {
        self.childComments = self.parentComments.map { reply in
            return self.childReplies(parentReplyId: reply.replyId)
        }
        print("fetchChildComments")
        print(self.childComments)
    }
    
    private func childReplies(parentReplyId: Int) -> [ChildReplyInfo]? {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .userInteractive)
        var childInfo: [ChildReplyInfo]? = nil
        guard let token = KeyChain.loadAccessToken(key: TokenType.accessToken.rawValue) else { return nil }

        let url = "http://na2ru2.me:6308/child-replies/1"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*"
        ]
        let parameters: Parameters = [
            "parentReplyId": parentReplyId,
            "pageNum": 1
        ]
        
        AF.request(
            url,
            method: .get,
            parameters: parameters,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: CommonResponseDtoFindChildReplyResDto.self, queue: queue) { response in
            switch response.result {
            case .success(let result):
                print(result)
                childInfo = result.result.childReplyInfoList
            case .failure(let error):
                print(String(describing: error.errorDescription))
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return childInfo
    }

    private func fetchUserProfile(loginId: String) {
        APIService.fetchUserProfile(loginId: loginId).performRequest(responseType: CommonResponseDtoUserProfileResDto.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let userProfile):
                    APIService.loadImageNonToken(data: userProfile.result.profileURL, imageView: self.replyImageView)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    // MARK: -- Setup CollectionView
    
    // collectionView dataSource
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CommentCollectionViewCell, Int> {
            (cell, indexPath, identifier) in
            if let section = self.childComments[indexPath.section] {
                cell.setupUI(comment: section[indexPath.row])
            }
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
            supplementaryView.setupUI(comment: self.parentComments[indexPath.section])
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<CommentSupplementaryFooterView>(elementKind: "footer") { supplementaryView, elementKind, indexPath in
            // footer 세팅
        }
        
        dataSource.supplementaryViewProvider = {(view, kind, index) in
            if kind == "header" {
                return self.commentCollectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            } else {
                let footerView = self.commentCollectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: index)
                
                // 답글이 있을 때만 표시
                if index.section < self.childComments.count,
                   let childReply = self.childComments[index.section]
                {
                    footerView.show()
                }
                return footerView
            }
        }
    }
    
    private func applySnapShot(data: [ParentReplyInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        
        var identifierOffset = 0 // 아이템의 identifier
        
        for idx in 0..<data.count {
            var itemPerSection = 0
            if idx < self.childComments.count,
               let childData = self.childComments[idx] {
                itemPerSection = childData.count
            }
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
        
        [separatorView2,
         separatorView3,
         replyStackView].forEach {
            inputContentView.addSubview($0)
        }
        
        [
            titleLabel,
            separatorView,
            commentCollectionView,
            inputContentView
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
        
        inputContentView.snp.makeConstraints {
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
            $0.height.equalTo(62)
        }
     
        separatorView2.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(replyStackView.snp.top)
            $0.height.equalTo(1)
        }
        
        replyStackView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(separatorView3.snp.top)
            $0.height.equalTo(60)
        }
        
        separatorView3.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        commentCollectionView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(replyStackView.snp.top)
        }
    }
}

extension CommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
