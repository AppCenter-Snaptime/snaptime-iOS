//
//  MainAlbumViewController.swift
//  snaptime
//
//  Created by Bowon Han on 2/1/24.
//

import Alamofire
import UIKit
import SnapKit

protocol MainAlbumViewControllerDelegate: AnyObject {
    func presentAlbumDetail(albumID: Int)
    func presentQRReaderView()
    func presentAddSnap()
}

final class MainAlbumViewController : BaseViewController {
    private var isAddButtonActive: Bool = false
    
    weak var delegate: MainAlbumViewControllerDelegate?
    
    // MARK: -- Fetch Data
    var albumData: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAlbumList() // 앨범목록 서버 통신
        self.fetchUserProfile(loginId: ProfileBasicManager.shared.profile.loginId)
//        self.fetchUserProfile(loginId: ProfileBasicModel.profile.loginId)
    }
    
    private let contentView = UIView()
    
    private lazy var albumButton : UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "folder")
        config.baseBackgroundColor = .white.withAlphaComponent(0)
        config.baseForegroundColor = .black
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in
            self?.presentAlbumSheet()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var mainAlbumCollectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var floatingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .trailing
        stackView.spacing = 7
        return stackView
    }()
    
    private lazy var addSnapFloatingButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .snaptimeBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "plus")
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.addAction(UIAction { [weak self] _ in
            self?.isAddButtonActive.toggle()
            self?.onTouchAddButton()
        }, for: .touchUpInside)
        return button
    }()
    
    private lazy var postFloatingStackView: UIStackView = {
        let stackView = UIStackView()
        let label = UILabel()
        label.text = "글쓰기"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .white
        config.baseForegroundColor = .snaptimeBlue
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "pencil")
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.presentAddSnap()
        }, for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        [label, button].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.alignment = .center
        stackView.bounds = view.frame.insetBy(dx: 8, dy: 0)
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var qrFloatingStackView: UIStackView = {
        let stackView = UIStackView()
        let label = UILabel()
        label.text = "QR인식하기"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .white
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = .white
        config.baseForegroundColor = .snaptimeBlue
        config.cornerStyle = .capsule
        config.image = UIImage(systemName: "qrcode.viewfinder")
        button.configuration = config
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.3
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.presentQRReaderView()
        }, for: .touchUpInside)
        button.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        [label, button].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.alignment = .center
        stackView.bounds = view.frame.insetBy(dx: 8, dy: 0)
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var floatingBackView: UIView = {
        let view = UIView(frame: self.view.frame)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.alpha = 0
        view.isHidden = true
        self.view.insertSubview(view, belowSubview: self.floatingStackView)
        return view
    }()
    
    private func fetchUserProfile(loginId: String) {
        APIService.fetchUserProfile(loginId: loginId).performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    if let profile = profile as? CommonResponseDtoUserProfileResDto {
                        UserProfileManager.shared.profile = profile
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func fetchAlbumList() {
        APIService.fetchAlbumList.performRequest { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albumList):
                    if let albumList = albumList as? CommonResponseDtoListFindAllAlbumsResDto {
                        self.albumData = albumList.result.map { Album($0) }
                    }
                    
                    self.mainAlbumCollectionView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func addNewAlbum(name: String) {
        let param: [String: String] = [
            "name": name
        ]
        APIService.postAlbum.performRequest(with: param) { result in
            switch result {
            case .success(let albumList):
                print("앨범 추가 성공")
                DispatchQueue.main.async {
                    self.fetchAlbumList()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: -- UI
    
    // + Floating Button 클릭시 실행
    private func onTouchAddButton() {
        rotateFloatingButton()
        setAdditionButtons()
        setBackground()
    }
    
    // 글쓰기, QR 버튼 띄우기
    private func setAdditionButtons() {
        if isAddButtonActive {
            [
                self.postFloatingStackView,
                self.qrFloatingStackView
            ].forEach { [weak self] view in
                view.isHidden = false
                view.alpha = 0
                UIView.animate(withDuration: 0.3) {
                    view.alpha = 1
                    self?.view.layoutIfNeeded()
                }
            }
        } else {
            [
                self.postFloatingStackView,
                self.qrFloatingStackView
            ].reversed().forEach { [weak self] view in
                UIView.animate(withDuration: 0.3) {
                    view.isHidden = true
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }
    
    // 배경 어둡게 하기
    private func setBackground() {
        if isAddButtonActive {
            self.floatingBackView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.floatingBackView.alpha = 1
            }
            
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.floatingBackView.alpha = 0
            }) { _ in
                self.floatingBackView.isHidden = true
            }
        }
    }
    
    // 버튼 + <-> x 모양으로 회전
    private func rotateFloatingButton() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        let fromValue = isAddButtonActive ? 0 : CGFloat.pi / 4
        let toValue = isAddButtonActive ? CGFloat.pi / 4 : 0
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        addSnapFloatingButton.layer.add(animation, forKey: nil)
    }
    
    private func presentAlbumSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "앨범 추가", style: .default, handler: { _ in
            self.presentAddAlbumPopup()
        }))
        actionSheet.addAction(UIAlertAction(title: "앨범 삭제", style: .destructive, handler: { _ in
            print("앨범 삭제")
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
    
    private func presentAddAlbumPopup() {
        let actionSheet = UIAlertController(title: "앨범 만들기", message: nil, preferredStyle: .alert)
        actionSheet.addTextField { myTF in
            myTF.placeholder = "앨범명"
        }
        actionSheet.addAction(UIAlertAction(title: "추가하기", style: .default, handler: { _ in
            print("앨범 추가")
            if let name = actionSheet.textFields?[0].text {
                self.addNewAlbum(name: name)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "취소하기", style: .cancel))
        self.present(actionSheet, animated: true)
        
    }
    
    // MARK: -- Layout & Constraints
    override func setupLayouts() {
        super.setupLayouts()
        [
            albumButton,
            mainAlbumCollectionView,
        ].forEach {
            contentView.addSubview($0)
        }
        
        [
            contentView,
            floatingStackView
        ].forEach {
            view.addSubview($0)
        }
        
        [
            postFloatingStackView,
            qrFloatingStackView,
            addSnapFloatingButton
        ].forEach {
            floatingStackView.addArrangedSubview($0)
        }
        
        self.setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: UIImageView(image: UIImage(named: "Logo")))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: albumButton)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        contentView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        mainAlbumCollectionView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(25)
            $0.left.right.equalTo(contentView)
            $0.bottom.equalTo(contentView)
        }
        
        floatingStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
        
        addSnapFloatingButton.snp.makeConstraints {
            $0.width.height.equalTo(64)
        }
        
        postFloatingStackView.snp.makeConstraints {
            $0.width.equalTo(92)
            $0.height.equalTo(50)
        }
        
        qrFloatingStackView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(50)
        }
    }
}

extension MainAlbumViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumCollectionViewCell.identifier,
            for: indexPath
        ) as? AlbumCollectionViewCell else { return UICollectionViewCell() }
        cell.setupUI(albumData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.presentAlbumDetail(albumID: albumData[indexPath.row].id)
    }
}

extension MainAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 23
        let availableWidth = width - spacing * (numberOfItemsPerRow + 1)
        let itemDimension = floor(availableWidth / numberOfItemsPerRow)
        return CGSize(width: itemDimension, height: itemDimension + 50)
    }
}
