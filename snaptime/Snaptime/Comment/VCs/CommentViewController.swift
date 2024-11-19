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
    private var isRepliesHidden: [Int:Bool] = [:]
    
    private var childComments: [Int:[ChildReplyInfo]] = [:]
    
    private var selectedCommentInfo: ParentReplyInfo?
    private var replyType: ReplyType = .parent
    
    private var hasNextPage: Bool = false
    private var pageNum: Int = 1
    private var isInfiniteScroll: Bool = true
    
    private enum ReplyType {
        case parent
        case child
    }
    
    weak var delegate: CommentViewControllerDelegate?
    
    var dataSource: UICollectionViewDiffableDataSource<Int, ChildReplyInfo>!
    
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
        self.fetchComment(pageNum: pageNum, snapId: self.snapID) {
            self.parentComments.forEach {
                self.childComments[$0.replyId] = nil
                self.isRepliesHidden[$0.replyId] = true
            }
        }
        
        guard let id = ProfileBasicUserDefaults().email else { return }
        
        self.fetchUserProfile(loginId: id)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        collectionView.delegate = self
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
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let success):
                            self.fetchComment(pageNum: self.pageNum, snapId: self.snapID) {
                                self.parentComments.forEach {
                                    self.childComments[$0.replyId] = nil
                                }
                                                                
                                self.isRepliesHidden[self.parentComments[self.parentComments.count-1].replyId] = true
                                self.applySnapShot(data: self.parentComments)
                            }
                            
                            self.replyTextField.text = ""
                            
                        case .failure(let failure):
                            let errorMessage = failure.localizedDescription
                            print("에러입니다: ",errorMessage)
                        }
                    }
                }
            case .child:
                guard let self = self,
                      let comment = self.replyTextField.text,
                      let commentInfo = self.selectedCommentInfo else {
                    return
                }
                
                let param = ChildReplyAddReqDto(replyMessage: comment, parentReplyId: commentInfo.replyId, tagEmail: "")
                
                APIService.postChildReply.performRequest(
                    with: param,
                    responseType: CommonResDtoVoid.self
                ) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let success):
                            self.fetchComment(pageNum: self.pageNum, snapId: self.snapID) {}
                            self.childComments[commentInfo.replyId] = self.childReplies(parentReplyId: commentInfo.replyId, pageNum: 1)
                            self.isRepliesHidden[commentInfo.replyId] = false
                            self.applySnapShot(data: self.parentComments)
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
                
                /// child 댓글이 숨겨져 있는지 여부에 따라 높이 설정
                let itemHeight: NSCollectionLayoutDimension = self.parentComments[sectionIndex].childReplyCnt <= 0 ? .estimated(0) : .estimated(40)

                /***
                
                 원 댓글 : Header
                 답글 : item
                 답글 추가/가리기 : Footer

                 **/
                
                /// 대댓글 item
                let item = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: itemHeight
                    )
                )
                
                /// 대댓글 item의 그룹
                let containerGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: itemHeight),
                    subitems: [item])
                containerGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0)
                
                /// 그룹을 section에 추가
                let section = NSCollectionLayoutSection(group: containerGroup)
                
                /// Header 설정
                let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(50)
                    ),
                    elementKind: "header",
                    alignment: .top
                )
                section.boundarySupplementaryItems.append(sectionHeader)

                /// childReplyCnt > 0인 경우(대댓글이 존재하는 경우)에만 footer 보여주기
                if self.parentComments[sectionIndex].childReplyCnt > 0 {
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
        let cellRegistration = UICollectionView.CellRegistration<CommentCollectionViewCell, ChildReplyInfo> {(
                cell,
                indexPath,
                item
            ) in
            
            cell.setupUI(comment: item)
            cell.commentView.addReplyButtonAction = {
                self.selectedCommentInfo = self.parentComments[indexPath.section]
                self.replyType = .child
                self.replyTextField.text = "@\(self.selectedCommentInfo?.writerUserName ?? "") "
                self.replyTextField.becomeFirstResponder()
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, ChildReplyInfo>(
            collectionView: commentCollectionView,
            cellProvider: ({(
                collectionView: UICollectionView,
                indexPath: IndexPath,
                item: ChildReplyInfo
            ) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration, 
                    for: indexPath,
                    item: item)
            })
        )
        
        let headerRegistration = UICollectionView.SupplementaryRegistration<CommentSupplementaryHeaderView>(
            elementKind: "header"
        ) {
                supplementaryView,
                elementKind,
                indexPath in

            supplementaryView.setupUI(comment: self.parentComments[indexPath.section])
            supplementaryView.contentView.action = {
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

            let parentComment = self.parentComments[indexPath.section]
            
            if parentComment.childReplyCnt > 0 {
                supplementaryView.changeButtonIsHidden()
                guard let isRepliesHidden = self.isRepliesHidden[parentComment.replyId] else { return }
                supplementaryView.setupHideButton(isHidden: isRepliesHidden)
            }
            
            /// 답글 가리기/보이기 버튼의 액션 설정
            supplementaryView.action = {
                self.isRepliesHidden[parentComment.replyId]?.toggle() // 숨김 상태 변경
                guard let isRepliesHidden = self.isRepliesHidden[parentComment.replyId] else { return }

                supplementaryView.setupHideButton(isHidden: isRepliesHidden)
                
                if !isRepliesHidden {
                    let parentReplyId = self.parentComments[indexPath.section].replyId
                    self.childComments[parentReplyId] = self.childReplies(parentReplyId: parentReplyId,pageNum: 1)
                }
                
                self.applySnapShot(data: self.parentComments)
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
    
    // MARK: -- Diffable DataSource apply 메서드
    private func applySnapShot(data: [ParentReplyInfo]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ChildReplyInfo>()
            
        for idx in 0..<data.count {
            snapshot.appendSections([idx])
            
            /// 숨김 상태일 경우, 아이템 추가하지 않음
            if let isRepliesHidden = isRepliesHidden[data[idx].replyId],
                !isRepliesHidden
            {
                guard let comment = self.childComments[data[idx].replyId] else { return }
                snapshot.appendItems(comment, toSection: idx)
            }
        }
        
        dataSource.apply(snapshot, animatingDifferences: true)
        self.commentCollectionView.layoutIfNeeded()
    }

    // MARK: -- Setup UI
    override func setupLayouts() {
        super.setupLayouts()
        
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
                
        replyTextField.layer.cornerRadius = 15
        replyTextField.clipsToBounds = true
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
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

// MARK: -- 댓글 목록 서버 통신
extension CommentViewController {
    private func fetchComment(pageNum: Int, snapId: Int, completion: @escaping () -> Void) {
        APIService.fetchParentReply(
            pageNum: pageNum,
            snapId: snapId
        ).performRequest(responseType: CommonResponseDtoListFindParentReplyResDto.self) { result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    if pageNum == 1 {
                        self.parentComments = result.result.parentReplyInfoResDtos
                    }
                    else {
                        self.parentComments.append(contentsOf: result.result.parentReplyInfoResDtos)
                    }
                    completion()
                    self.applySnapShot(data: self.parentComments)
                    self.hasNextPage = result.result.hasNextPage
                    
                    if self.hasNextPage {
                        self.pageNum += 1
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    
    private func childReplies(parentReplyId: Int, pageNum: Int) -> [ChildReplyInfo]? {
        let semaphore = DispatchSemaphore(value: 0)
        let queue = DispatchQueue.global(qos: .userInteractive)
        var childInfo: [ChildReplyInfo]? = nil
        guard let token = KeyChain.loadAccessToken(key: TokenType.accessToken.rawValue) else { return nil }

        let url = "http://na2ru2.me:6308/child-replies/\(pageNum)?parentReplyId=\(parentReplyId)"
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

extension CommentViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    /// 남은 content size 의 높이보다 스크롤을 많이 했다. 즉, 다음 컨텐츠가 필요한 경우.
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            print("들어옴")
            if isInfiniteScroll && hasNextPage {
                isInfiniteScroll = false
                
                fetchComment(pageNum: pageNum, snapId: snapID) {
                    self.isInfiniteScroll = true
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
