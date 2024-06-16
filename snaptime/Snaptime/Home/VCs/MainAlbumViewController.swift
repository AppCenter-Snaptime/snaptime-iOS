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
    private let contentView = UIView()
    
    private lazy var addSnapButton : UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "folder")
        config.baseBackgroundColor = .white.withAlphaComponent(0)
        config.baseForegroundColor = .black
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in
            self?.delegate?.presentAddSnap()
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
    
    private var isAddButtonActive: Bool = false
    
    weak var delegate: MainAlbumViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAlbumList() // 앨범목록 서버 통신
    }
    
    // MARK: -- Fetch Data
    var albumData: [Album] = [
        Album(id: 0, name: "최근 항목", photoURL: ""),
        Album(id: 1, name: "2024", photoURL: ""),
        Album(id: 2, name: "2023", photoURL: ""),
        Album(id: 3, name: "2022", photoURL: ""),
        Album(id: 4, name: "Alone", photoURL: "")
    ]
    
    private func fetchAlbumList() {
        let url = "http://na2ru2.me:6308/album/albumListWithThumbnail"
        let headers: HTTPHeaders = [
            "Authorization": ACCESS_TOKEN,
            "accept": "*/*"
        ]
        AF.request(
            url,
            method: .get,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseJSON { response in
            switch response.result {
            case .success(let data):
                print("success")
                print(data)
                guard let data = response.data else { return }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(AlbumListResponse.self, from: data)
                    print(result)
                    self.albumData = result.result.map { Album($0) }
                    DispatchQueue.main.async {
                        self.mainAlbumCollectionView.reloadData()
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(String(describing: error.errorDescription))
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
    
    // MARK: -- Layout & Constraints
    override func setupLayouts() {
        super.setupLayouts()
        [
            addSnapButton,
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addSnapButton)
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
