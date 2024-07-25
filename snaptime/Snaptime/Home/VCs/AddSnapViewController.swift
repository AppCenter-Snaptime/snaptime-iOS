//
//  AddSnapViewController.swift
//  Snaptime
//
//  Created by Bowon Han on 4/2/24.
//

import Alamofire
import UIKit
import SnapKit

protocol AddSnapViewControllerDelegate: AnyObject {
    func presentAddSnap()
    func presentSnapTagList()
}

final class AddSnapViewController: BaseViewController {
    weak var delegate: AddSnapViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImage.layer.cornerRadius = profileImage.frame.height/2
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
        button.addAction(UIAction { _ in
            button.tag = 1
            self.tabImageButton(tag: 1)
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var addTagButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.borderedTinted()
        
        var titleAttr = AttributedString.init("사람 태그")
        titleAttr.font = .systemFont(ofSize: 14, weight: .regular)
        
        config.attributedTitle = titleAttr
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.image = UIImage(systemName: "person")
        config.cornerStyle = .large
        config.baseForegroundColor = .snaptimeBlue
        config.baseBackgroundColor = .white
        config.background.strokeWidth = 1
        config.background.strokeColor = .snaptimeGray
        
        button.configuration = config
        button.addAction(UIAction {[weak self] _ in
            self?.delegate?.presentSnapTagList()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var snapSaveButton: UIButton = {
        let button = SnapTimeCustomButton("작성 완료")
        button.addAction(UIAction { [weak self] _ in
            Task {
                await self?.postNewSnap()
                self?.navigationController?.popViewController(animated: true)
            }
        }, for: .touchUpInside)
        return button
    }()
    
    private func tabImageButton(tag: Int) {
        let imagePicker = UIImagePickerController()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true

        imagePicker.view.tag = tag

        self.present(imagePicker, animated: true)
    }
    
    private func postNewSnap() async {
        // 아직 parameter isPrivate 안 보냄
        
        let url = "http://na2ru2.me:6308/snap?isPrivate=false"
        guard let token = TokenUtils().read(APIService.baseURL, account: "accessToken") else { return }
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
            print(error.errorDescription)
        }
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        
        [profileImage,
         oneLineDiaryTextView,
         addImageButton,
         addTagButton,
         snapSaveButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
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
        
        addTagButton.snp.makeConstraints {
            $0.top.equalTo(addImageButton.snp.bottom).offset(24)
            $0.left.equalTo(addImageButton.snp.left)
            $0.height.equalTo(32)
            $0.width.equalTo(109)
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

extension AddSnapViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false) { () in
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            
            if let tag = picker.view?.tag {
                switch tag {
                case 1:
                    self.addImageButton.setImage(image, for: .normal)
                default:
                    break
                }
            }
        }
    }
}
