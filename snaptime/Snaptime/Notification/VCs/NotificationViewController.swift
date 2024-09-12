//
//  NotificationViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 3/18/24.
//

import UIKit
import SnapKit
import Alamofire

protocol NotificationViewControllerDelegate: AnyObject {
    func presentNotification()
    func presentProfile(target: ProfileTarget, loginId: String)
    func presentSnap(snapId: Int, profileType: ProfileTarget)
}

final class NotificationViewController: BaseViewController {
    weak var delegate: NotificationViewControllerDelegate?
    
    private var notifications: [AlarmInfoResDto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        fetchAlarms()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchAlarms()
    }
    
    private lazy var topTextLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = UIColor.init(hexCode: "003E6E")
        
        return label
    }()
    
    private lazy var topBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    private lazy var notificationCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(NotificationCollectionViewCell.self, 
                                forCellWithReuseIdentifier: NotificationCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private func fetchAlarms() {
        APIService.fetchAlarms.performRequest(
            responseType: CommonResponseDtoAlarmFindAllResDto.self
        ) { result in
            switch result {
            case .success(let notifications):
                DispatchQueue.main.async {
                    // NOTE: - 읽은알림, 안읽은 알림 구별방법 생각해보기
                    self.notifications = notifications.result.notReadAlarmInfoResDtos + notifications.result.readAlarmInfoResDtos
                    self.notificationCollectionView.reloadData()
                    LoadingService.hideLoading()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupNavigationBar() {
        self.showNavigationBar()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: topTextLabel)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [notificationCollectionView].forEach {
            view.addSubview($0)
        }
        
        notificationCollectionView.snp.makeConstraints {
            $0.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = notificationCollectionView.dequeueReusableCell(
            withReuseIdentifier: NotificationCollectionViewCell.identifier,
            for: indexPath) as? NotificationCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        let alarmType = NotificationType(title: notifications[indexPath.row].alarmType)
        cell.configureData(data: notifications[indexPath.row], type: alarmType)
        
        switch alarmType {
        case .follow:
            break
        case .reply:
            break
        case .like, .snapTag:
            cell.previewImageClickAction = {
                var snapResult = FindSnapResDto(
                    snapId: 0,
                    oneLineJournal: "",
                    snapPhotoURL: "",
                    snapCreatedDate: "",
                    snapModifiedDate: "",
                    writerLoginId: "",
                    profilePhotoURL: "",
                    writerUserName: "",
                    tagUserFindResDtos: [],
                    likeCnt: 0,
                    isLikedSnap: false
                )
                
                APIService.fetchAlarmSnap(
                    alarmId: self.notifications[indexPath.row].alarmId
                ).performRequest(responseType: CommonResponseDtoFindSnapResDto.self) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let snap):
                            
                            snapResult = snap.result
                            
                            var profileType: ProfileTarget = .others
                            
                            if snapResult.writerLoginId == ProfileBasicUserDefaults().loginId {
                                profileType = .myself
                            }
                            
                            print(snapResult)
                            
                            self.delegate?.presentSnap(snapId: snapResult.snapId, profileType: profileType)
                            
                        case .failure(let failure):
                            // NSError로부터 에러 메시지를 추출
                            let errorMessage = failure.localizedDescription

                            print("에러 발생: \(errorMessage)")
                            
                            // 알림 팝업 등에 에러 메시지 표시
                            self.show(
                                alertText: errorMessage,
                                cancelButtonText: "알겠습니다",
                                confirmButtonText: "네",
                                identifier: "error"
                            )
                        }
                    }
                }
            }
        }

        
        cell.profileImageClickAction = {
            
        }
        
        return cell
    }
}

extension NotificationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /// 수정필요
        let height: CGFloat = 86
        let width : CGFloat = collectionView.frame.width
        
        return CGSize(width: width, height: height)
    }
}

extension NotificationViewController: CustomAlertDelegate {
    func exit(identifier: String) {}
    func action(identifier: String) {}
}
