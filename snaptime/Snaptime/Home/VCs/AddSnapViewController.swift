//
//  AddSnapViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 4/2/24.
//

import Alamofire
import UIKit
import SnapKit
import Kingfisher
import PhotosUI
import Kingfisher

protocol AddSnapViewControllerDelegate: AnyObject {
    func presentAddSnap()
    func presentSnapTagList()
    func presentSelectAlbumVC()
    func backToRoot()
}

enum EditSnapMode {
    case add
    case edit
}

final class AddSnapViewController: BaseViewController {
    weak var delegate: AddSnapViewControllerDelegate?
    
    private var userProfile = UserProfileManager.shared.profile.result
    private var tagList: [FindTagUserResDto] = []
    private var editMode: EditSnapMode = .add
    private var snapId: Int = -1
    private var isSnapPrivate: Bool = false
    
    private var qrImageUrl: String?
    
    init(qrImageUrl: String? = nil) {
        self.qrImageUrl = qrImageUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        setupNavigationBar()
        
        APIService.loadImageNonToken(data: userProfile.profileURL, imageView: profileImage)
        
        if let qrImageUrl = self.qrImageUrl,
           let url = URL(string: qrImageUrl),
           let token = KeyChain.loadAccessToken(key: TokenType.accessToken.rawValue){
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("*/*", forHTTPHeaderField: "accept")
                r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                return r
            }
            
            addImageButton.kf.setImage(with: url, for: .normal, options: [.requestModifier(modifier)])
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
    }
    
    func addTagList(tagList: [FindTagUserResDto]) {
        // 기존 태그 리스트가 없으면, 초기 '사람 태그' 버튼을 지워주고,
        // + 버튼을 보여줌
        if self.tagList.isEmpty {
            self.tagStackView.arrangedSubviews.forEach {
                $0.removeFromSuperview()
            }
            self.addTagButton.isHidden = false
        }
        print("addTagList")
        print(tagList)
        self.tagList.append(contentsOf: tagList)
        tagList.forEach {
            self.tagStackView.addArrangedSubview(TagButton(tagName: $0.tagUserName))
        }
    }
    
    // 수정 모드일 때 초기 상태 설정
    func setEditMode(snap: FindSnapResDto) {
        self.editMode = .edit
        self.snapId = snap.snapId
        self.oneLineDiaryTextView.text = snap.oneLineJournal
        self.oneLineDiaryTextView.textColor = .black
        self.isSnapPrivate = snap.snapPhotoURL.contains("isEncrypted=true")
        self.privateButton.isSelected = snap.snapPhotoURL.contains("isEncrypted=true")
        
        if let url = URL(string: snap.snapPhotoURL),
           let token = KeyChain.loadAccessToken(key: TokenType.accessToken.rawValue) {
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("*/*", forHTTPHeaderField: "accept")
                r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                return r
            }
            KingfisherManager.shared.retrieveImage(with: url, options: [.requestModifier(modifier)]) { result in
                switch result {
                case .success(let data):
                    self.addImageButton.setImage(data.image, for: .normal)
                case .failure(let error):
                    print(error)
                }
            }
        }
        if !snap.tagUserFindResDtos.isEmpty {
            self.addTagList(tagList: snap.tagUserFindResDtos)
        }
        self.snapSaveButton.setTitle("수정 완료", for: .normal)
    }
    
    private lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .snaptimeGray
        
        return image
    }()
    
    private lazy var oneLineDiaryTextView: UITextView = {
        let textView = UITextView()
        textView.text = "글을 입력하세요."
        textView.textColor = .snaptimeGray
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.isScrollEnabled = false
        textView.delegate = self
        
        return textView
    }()
    
    private lazy var addImageButton: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor.snaptimeGray.cgColor
        button.imageView?.contentMode = .scaleAspectFit
        button.addAction(UIAction { _ in
            self.tabImageButton()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var privateButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.borderedTinted()
        
        config.background.strokeWidth = 1
        config.background.strokeColor = UIColor.init(hexCode: "bebebe")
        button.configuration = config
        button.isSelected = false
        
        button.addAction(UIAction{ [weak self] _ in
            self?.isTappedPrivateButton()
        }, for: .touchUpInside)
        
        button.configurationUpdateHandler = { btn in
            switch btn.state {
            case .selected:
                btn.configuration?.image = UIImage(systemName: "lock")
                btn.configuration?.baseForegroundColor = .white
                btn.configuration?.baseBackgroundColor = UIColor.init(hexCode: "bebebe")
            default:
                btn.configuration?.image = UIImage(systemName: "lock.open")
                btn.configuration?.baseForegroundColor = UIColor.init(hexCode: "bebebe")
                btn.configuration?.baseBackgroundColor = .white
            }
        }
        
        return button
    }()
    
    private lazy var initialAddTagButton: UIButton = {
        let button = TagButton(tagName: "사람 태그", action: UIAction {[weak self] _ in
            self?.delegate?.presentSnapTagList()
        })
        return button
    }()
    
    private lazy var tagStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(self.initialAddTagButton)
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var addTagButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.borderedTinted()
        config.imagePlacement = .leading
        config.imagePadding = 10
        config.image = UIImage(systemName: "plus")
        config.cornerStyle = .capsule
        config.baseForegroundColor = .snaptimeBlue
        config.baseBackgroundColor = .white
        config.background.strokeWidth = 1
        config.background.strokeColor = .snaptimeGray
        
        button.configuration = config
        button.addAction(UIAction {[weak self] _ in
            self?.delegate?.presentSnapTagList()
        }, for: .touchUpInside)
        button.isHidden = true // 초기에 안보이게 설정
        return button
    }()
    
    private lazy var snapSaveButton: UIButton = {
        let button = SnapTimeCustomButton("작성 완료")
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            if self.editMode == .edit {
                Task {
                    await self.putNewSnap()
                    self.delegate?.backToRoot()
                }
            }
            else {
                // select album id 받아와서 이후 delegate에서 postNewSnap 호출
                self.delegate?.presentSelectAlbumVC()
            }
        }, for: .touchUpInside)
        return button
    }()
    
    private func tabImageButton() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .videos])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func isTappedPrivateButton() {
        if !isSnapPrivate {
            privateButton.isSelected.toggle()
        }
        
        else {
            privateButton.isSelected.toggle()
        }
        
        isSnapPrivate.toggle()
    }
    
    private func setupNavigationBar() {
        self.showNavigationBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: privateButton)
    }
    
    func postNewSnap(albumId: Int) async {
        // 아직 parameter isPrivate 안 보냄
        
        var url = "http://na2ru2.me:6308/snap?isPrivate=\(self.isSnapPrivate)&albumId=\(albumId)"
        guard let token = KeyChain.loadAccessToken(key: TokenType.accessToken.rawValue) else { return }
        
        self.tagList.forEach {
            url += "&tagUserLoginIds=\($0.tagUserLoginId)"
        }
        
        var headers: HTTPHeaders {
            ["Authorization": "Bearer \(token)", "accept": "*/*", "Content-Type": "multipart/form-data"]
        }
        guard let image = addImageButton.image(for: .normal),
              let jpgimageData = image.jpegData(compressionQuality: 0.2),
              let oneLineJournal = oneLineDiaryTextView.text
        else {
            return
        }
        let response = await AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(oneLineJournal.utf8), withName: "oneLineJournal")
            multipartFormData.append(jpgimageData, withName: "multipartFile", fileName: "image.png", mimeType: "image/jpeg")
        }, to: url, method: .post, headers: headers)
            .serializingDecodable(CommonResponseDtoLong.self)
            .response
        print("hi")
        print(response)
        switch response.result {
        case .success(let res):
            if (400..<599).contains(response.response?.statusCode ?? 0) {
                print("error : ", res.msg)
            }
            else {
                print("스냅 전송 성공!")
            }
        case .failure(let error):
            print(error)
        }
    }
    
    private func putNewSnap() async {
        guard self.snapId != -1 else { return }
        var url = "http://na2ru2.me:6308/snap?isPrivate=\(self.isSnapPrivate)&snapId=\(self.snapId)"
        guard let token = KeyChain.loadAccessToken(key: TokenType.accessToken.rawValue) else { return }
        
        self.tagList.forEach {
            url += "&tagUserLoginIds=\($0.tagUserLoginId)"
        }
        
        var headers: HTTPHeaders {
            ["Authorization": "Bearer \(token)", "accept": "*/*", "Content-Type": "multipart/form-data"]
        }
        guard let image = addImageButton.image(for: .normal),
              let jpgimageData = image.jpegData(compressionQuality: 0.2),
              let oneLineJournal = oneLineDiaryTextView.text
        else {
            return
        }
        let response = await AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(Data(oneLineJournal.utf8), withName: "oneLineJournal")
            multipartFormData.append(jpgimageData, withName: "multipartFile", fileName: "image.png", mimeType: "image/jpeg")
        }, to: url, method: .put, headers: headers)
            .serializingDecodable(CommonResponseDtoLong.self)
            .response
        print(response)
        switch response.result {
        case .success(let res):
            if (400..<599).contains(response.response?.statusCode ?? 0) {
                print("error : ", res.msg)
            }
            else {
                print("스냅 수정 성공!")
            }
        case .failure(let error):
            guard let errorMessage = error.errorDescription else { return }
            print(errorMessage)
        }
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [
            initialAddTagButton
        ].forEach {
            tagStackView.addArrangedSubview($0)
        }
        
        [profileImage,
         oneLineDiaryTextView,
         addImageButton,
         tagStackView,
         addTagButton,
         snapSaveButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        privateButton.snp.makeConstraints {
            $0.width.height.equalTo(35)
        }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            $0.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.height.equalTo(40)
            $0.width.equalTo(40)
        }
        
        oneLineDiaryTextView.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.top)
            $0.left.equalTo(profileImage.snp.right).offset(20)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.height.lessThanOrEqualTo(200)
        }
        
        addImageButton.snp.makeConstraints {
            $0.top.equalTo(oneLineDiaryTextView.snp.bottom).offset(10)
            $0.left.equalTo(oneLineDiaryTextView.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.height.equalTo(454)
        }
        
        tagStackView.snp.makeConstraints {
            $0.top.equalTo(addImageButton.snp.bottom).offset(24)
            $0.left.equalTo(addImageButton.snp.left)
            $0.height.equalTo(32)
        }
        
        addTagButton.snp.makeConstraints {
            $0.top.bottom.equalTo(self.tagStackView)
            $0.left.equalTo(self.tagStackView.snp.right).offset(8)
            $0.width.equalTo(self.addTagButton.snp.height)
        }
        
        snapSaveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-15)
            $0.left.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(44)
        }
    }
}

extension AddSnapViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .snaptimeGray else { return }
        textView.text = nil
        textView.textColor = .black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "메세지를 입력하세요"
            textView.textColor = .snaptimeGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else { return }
                
        // 글자수 제한
//        let maxLength = 100
//        if text.count > maxLength {
//            textView.text = String(text.prefix(maxLength))
//        }
        
        // 줄바꿈(들여쓰기) 제한
        let maxNumberOfLines = 8
        let lineBreakCharacter = "\n"
        let lines = text.components(separatedBy: lineBreakCharacter)
        var consecutiveLineBreakCount = 0 // 연속된 줄 바꿈 횟수

        for line in lines {
            if line.isEmpty { // 빈 줄이면 연속된 줄 바꿈으로 간주
                consecutiveLineBreakCount += 1
            } else {
                consecutiveLineBreakCount = 0
            }

            if consecutiveLineBreakCount > maxNumberOfLines {
                textView.text = String(text.dropLast()) // 마지막 입력 문자를 제거
                break
            }
        }
        
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        textView.constraints.forEach { (constraint) in
          /// 180 이하일때는 더 이상 줄어들지 않게하기
            if estimatedSize.height <= 180 {
                
            }
            
            else {
                if constraint.firstAttribute == .height {
                    constraint.constant = estimatedSize.height
                }
            }
        }
    }
}

//MARK: - 피커뷰 델리게이트
extension AddSnapViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let itemProvider = results.first?.itemProvider else {
            print("이미지를 찾을 수 없습니다!")
            return
        }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self.addImageButton.setImage(image, for: .normal)
                    }
                } else {
                    print("로드된 객체를 UIImage로 캐스팅하지 못했습니다.")
                }
            }
        } else {
            print("UIImage를 로드할 수 없습니다.")
        }
    }
}
