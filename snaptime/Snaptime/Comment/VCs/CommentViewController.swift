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
    func presentProfile(target: ProfileTarget, email: String)
}

final class CommentViewController: BaseViewController {
    private let snapID: Int
    private let snapUserName: String
    private var parentComments: [ParentReplyInfo] = []
    private var childComments: [[ChildReplyInfo]?] = []
    private var isRepliesHidden: [Bool] = []
    
    private var selectedCommentInfo: ParentReplyInfo?
    private var replyType: ReplyType = .parent
    
    private enum ReplyType {
        case parent
        case child
    }
    
    weak var delegate: CommentViewControllerDelegate?
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Int>!
    
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
        
        guard let id = ProfileBasicUserDefaults().email else { return }
        
        self.fetchUserProfile(loginId: id)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
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
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    private lazy var replyImageView: RoundImageView = {
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
            switch self?.replyType {
            case .parent:
                guard let self = self,
                      let comment = self.replyTextField.text else {
                    return
                }
                
                let param = AddParentReplyReqDto(replyMessage: comment, snapId: self.snapID)

                APIService.postParentReply.performRequest(
                    with: param,
                    responseType: CommonResDtoVoid.self
                ) { [weak self] _ in
                    DispatchQueue.main.async {
                        guard let id = self?.snapID else { return }
                        self?.fetchComment(pageNum: 1, snapId: id)
                        self?.replyTextField.text = ""
                    }
                }
            case .child:
                guard let self = self,
                      let comment = self.replyTextField.text,
                      let commentInfo = self.selectedCommentInfo else {
                    return
                }
                
                let param = ChildReplyAddReqDto(replyMessage: comment, parentReplyId: commentInfo.replyId, tagEmail: "")
                print(param)
                
                APIService.postChildReply.performRequest(
                    with: param,
                    responseType: CommonResDtoVoid.self
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let success):
                            self.fetchComment(pageNum: 1, snapId: self.snapID)
                            self.replyTextField.text = ""
                            self.replyType = .parent
                            
                        case .failure(let failure):
                            let errorMessage = failure.localizedDescription
                            print("에러입니다: ",errorMessage)
                        }
                    }
                }
                
            case .none:
                break
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
    
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
       
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
        
    private func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: { (
                sectionIndex: Int,
                layoutEnvironment: NSCollectionLayoutEnvironment
            ) -> NSCollectionLayoutSection? in
                
                // child 댓글이 숨겨져 있는지 여부에 따라 높이 설정
                let itemHeight: NSCollectionLayoutDimension = self.isRepliesHidden[sectionIndex] ? .estimated(0) : .estimated(40)
                
                /*
                
                 원 댓글 : Header
                 답글 : item
                 답글 추가/가리기 : Footer

                 */
                
                /// 대댓글 item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: itemHeight
                    )
                )
                
                // 대댓글 item의 그룹
                let containerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: itemHeight),
                    subitems: [item])
                containerGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0)
                
                // 그룹을 section에 추가
                let section = NSCollectionLayoutSection(group: containerGroup)
                
                // Header 설정
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(50)
                    ),
                    elementKind: "header",
                    alignment: .top
                )
                section.boundarySupplementaryItems.append(sectionHeader)
                
                // Footer 설정 (child 댓글이 있는 경우만 추가)
                if let childComments = self.childComments[sectionIndex], !childComments.isEmpty {
                    let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .estimated(7)
                        ),
                        elementKind: "footer",
                        alignment: .bottom)
                    sectionFooter.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0)
                    section.boundarySupplementaryItems.append(sectionFooter)
                }
                
                return section
            }, configuration: config)
        
        return layout
    }
    
    private func setupDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<CommentCollectionViewCell, Int> {(
                cell,
                indexPath,
                identifier
            ) in
            
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
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<CommentSupplementaryHeaderView>(
            elementKind: "header"
        ) {
                supplementaryView,
                elementKind,
                indexPath in
            // header 세팅
            supplementaryView.setupUI(comment: self.parentComments[indexPath.section])
            supplementaryView.contentView.action = {
                print("event")
                
                var target: ProfileTarget = .others
                
                if self.parentComments[indexPath.section].writerEmail == ProfileBasicUserDefaults().email {
                    target = .myself
                }
                
                self.delegate?.presentProfile(target: target, email: self.parentComments[indexPath.section].writerEmail)
            }
            
            supplementaryView.contentView.addReplyButtonAction = {
                self.selectedCommentInfo = self.parentComments[indexPath.section]
                self.replyType = .child
                self.replyTextField.text = "@\(self.selectedCommentInfo?.writerUserName ?? "") "
                self.replyTextField.becomeFirstResponder()
            }
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration<CommentSupplementaryFooterView>(
            elementKind: "footer"
        ) {
            supplementaryView,
            elementKind,
            indexPath in
            // footer 세팅
            if self.childComments[indexPath.section] != nil {
                supplementaryView.changeButtonIsHidden()
                supplementaryView.setupHideButton(isHidden: self.isRepliesHidden[indexPath.section])
            }
            
                // 답글 가리기/보이기 버튼의 액션 설정
            supplementaryView.action = {
                self.isRepliesHidden[indexPath.section].toggle() // 숨김 상태 변경
                supplementaryView.setupHideButton(isHidden: self.isRepliesHidden[indexPath.section])
                
                self.applySnapShot(data: self.parentComments) // 스냅샷 업데이트
            }
        }
        
        dataSource.supplementaryViewProvider = {(view, kind, index) in
            if kind == "header" {
                return self.commentCollectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            } else {
                return self.commentCollectionView.dequeueConfiguredReusableSupplementary(using: footerRegistration, for: index)
            }
        }
    }
    
//    private func applySnapShot(data: [ParentReplyInfo]) {
//        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
//
//        var identifierOffset = 0 // 아이템의 identifier
//
//        for idx in 0..<data.count {
//            var itemPerSection = 0
//            if idx < self.childComments.count,
//               let childData = self.childComments[idx] {
//                itemPerSection = childData.count
//            }
//            snapshot.appendSections([idx])
//
//            let maxIdentifier = identifierOffset + itemPerSection
//            snapshot.appendItems(Array(identifierOffset..<maxIdentifier))
//            identifierOffset += itemPerSection
//        }
//
//        dataSource.apply(snapshot)
//    }
    
    private func applySnapShot(data: [ParentReplyInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        var identifierOffset = 0 // 아이템의 identifier
            
        for idx in 0..<data.count {
            snapshot.appendSections([idx])
            
            // 숨김 상태일 경우, 아이템 추가하지 않음
            if !isRepliesHidden[idx] {
                var itemPerSection = 0
                if let childData = self.childComments[idx] {
                    itemPerSection = childData.count
                }
                
                let maxIdentifier = identifierOffset + itemPerSection
                snapshot.appendItems(Array(identifierOffset..<maxIdentifier), toSection: idx)
                identifierOffset += itemPerSection
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
        self.commentCollectionView.layoutIfNeeded()
    }
    
//    private func toggleRepliesVisibility(for section: Int) {
////        guard let currentSnapshot = dataSource.snapshot() else { return }
//        
//        // 해당 섹션의 자식 댓글을 가져옴
//        guard let childData = self.childComments[section] else { return }
//        
//        var newSnapshot = dataSource.snapshot()
//        
//        if isRepliesHidden[section] {
//            // 자식 댓글을 보이게 할 경우: 자식 댓글 추가
//            let identifierOffset = newSnapshot.numberOfItems(inSection: section)
//            let itemRange = Array(identifierOffset..<identifierOffset + childData.count)
//            newSnapshot.appendItems(itemRange, toSection: section)
//        } else {
//            // 자식 댓글을 숨길 경우: 해당 섹션에서 자식 댓글 삭제
//            let itemsToRemove = newSnapshot.itemIdentifiers(inSection: section)
//            newSnapshot.deleteItems(itemsToRemove)
//        }
//        
//        // 스냅샷을 적용
//        dataSource.apply(newSnapshot, animatingDifferences: true)
//    }

    // MARK: -- Setup UI
    override func setupLayouts() {
        [replyImageView,
        replyTextField,
        replySubmitButton].forEach {
            replyStackView.addArrangedSubview($0)
        }
        
        [separatorView2,
         separatorView3,
         replyStackView].forEach {
            inputContentView.addSubview($0)
        }
        
        [titleLabel,
        separatorView,
        commentCollectionView,
        inputContentView].forEach {
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
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
            $0.bottom.equalTo(separatorView2.snp.top).offset(-1)
        }
    }
}

extension CommentViewController {
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
                    self.fetchChildComments()
                    self.isRepliesHidden = Array(repeating: true, count: self.parentComments.count)
                    self.applySnapShot(data: self.parentComments)
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

        let url = "http://na2ru2.me:6308/child-replies/1?parentReplyId=\(parentReplyId)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "accept": "*/*"
        ]
            
        AF.request(
            url,
            method: .get,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: CommonResponseDtoFindChildReplyResDto.self, queue: queue) { response in
            switch response.result {
            case .success(let result):
                childInfo = result.result.childReplyInfoResDtos
            case .failure(let error):
                print(String(describing: error.errorDescription))
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        return childInfo
    }

    private func fetchUserProfile(loginId: String) {
        APIService.fetchUserProfile(email: loginId).performRequest(responseType: CommonResponseDtoUserProfileResDto.self) { result in
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
}

extension CommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
