//
//  APIService.swift
//  Snaptime
//
//  Created by Bowon Han on 5/23/24.
//

import Foundation
import Alamofire
import Kingfisher

enum FetchError: Error {
    case invalidStatus
    case jsonDecodeError
    case jsonEncodeError
}

enum APIService {
    static let baseURL = "http://na2ru2.me:6308"
    
    case signIn
    case signUp
    
    case fetchUserProfile(loginId: String)
    case fetchUserProfileCount(loginId: String)
    case fetchUserAlbum(loginId: String)
    case fetchUserTagSnap(loginId: String)
    case fetchUserInfo
    case modifyUserInfo
    
    case fetchCommunitySnap(pageNum: Int)
    case fetchSnap(albumId: Int)
    case fetchSnapPreview(albumId: Int)
    case fetchAlbumList
    case postAlbum
    
    case fetchFollow(type: String, loginId: String, keyword: String, pageNum: Int)
    case postFollow(loginId: String)
    case deleteFollowing(loginId: String)
    
    case postReply
}

extension APIService {
    var path: String {
        switch self {
            
        case .signIn:
            "/users/sign-in"
            
        case .signUp:
            "/users/sign-up"
            
        case .fetchUserProfile(let loginId):
            "/profiles/profile?targetLoginId=\(loginId)"
    
        case .fetchUserProfileCount(let loginId):
            "/profiles/count?loginId=\(loginId)"
            
        case .fetchUserAlbum(let loginId):
            "/profiles/album-snap?targetLoginId=\(loginId)"
            
        case .fetchUserTagSnap(let loginId):
            "/profiles/tag-snap?loginId=\(loginId)"
            
        case .fetchUserInfo:
            "/users"
            
        case .modifyUserInfo:
            "/users"
            
        case .fetchCommunitySnap(let pageNum):
            "/community/snaps/\(pageNum)"
            
        case .fetchSnap(let snapId):
            "/snap/\(snapId)"
            
        case .fetchSnapPreview(let albumId):
            "/album/\(albumId)"
            
        case .fetchAlbumList:
            "/album/albumListWithThumbnail"
            
        case .postAlbum:
            "/album"
            
        case .fetchFollow(let type, let loginId, let keyword, let pageNum):
            "/friends/\(pageNum)?targetLoginId=\(loginId)&friendSearchType=\(type)"
            
        case .postFollow(let loginId):
            "/friends?receiverLoginId=\(loginId)"
            
        case .deleteFollowing(let loginId):
            "/friends?deletedUserLoginId=\(loginId)"
            
        case .postReply:
            "/parent-replies"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUserProfile,
            .fetchUserProfileCount,
            .fetchUserAlbum,
            .fetchUserTagSnap,
            .fetchCommunitySnap,
            .fetchSnap,
            .fetchUserInfo,
            .fetchSnapPreview,
            .fetchAlbumList,
            .fetchFollow:
                .get
            
        case .modifyUserInfo:
                .put
        
        case .postReply,
            .postFollow,
            .postAlbum,
            .signIn,
            .signUp:
                .post
            
        case .deleteFollowing:
                .delete
        }
    }
    
    var url: URL {
        return URL(string: APIService.baseURL + path)!
    }
    
    var headers: HTTPHeaders {
        guard let token = TokenUtils().read(APIService.baseURL, account: "accessToken") else { return ["accept": "*/*", "Content-Type": "application/json"]}
        return ["Authorization": "Bearer \(token)", "accept": "*/*", "Content-Type": "application/json"]
    }
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        return request
    }
    
    func performRequest(with parameters: Encodable? = nil, completion: @escaping (Result<Any, Error>) -> Void) {
        var request = self.request
        print(url)

        if let parameters = parameters {
            do {
                let jsonData = try JSONEncoder().encode(parameters)
                request.httpBody = jsonData
            } catch {
                completion(.failure(FetchError.jsonEncodeError))
                return
            }
        }

        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    guard let data = response.data else { return }
                    
                    do {
                        if case .fetchUserProfile = self {
                            let userProfile = try JSONDecoder().decode(CommonResponseDtoUserProfileResDto.self, from: data)
                            completion(.success(userProfile))
                        }
                        
                        else if case .signIn = self {
                            let token = try JSONDecoder().decode(CommonResponseDtoSignInResDto.self, from: data)
                            completion(.success(token.result))
                        }
                                                
                        else if case .fetchUserProfileCount = self {
                            let userProfileCount = try JSONDecoder().decode(CommonResponseDtoProfileCntResDto.self, from: data)
                            completion(.success(userProfileCount))
                        }
                        
                        else if case .fetchUserAlbum = self {
                            let userAlbum = try JSONDecoder().decode(CommonResponseDtoListAlbumSnapResDto.self, from: data)
                            completion(.success(userAlbum))
                        }
                        
                        else if case .fetchUserTagSnap = self {
                            let tagList = try JSONDecoder().decode(CommonResponseDtoListProfileTagSnapResDto.self, from: data)
                            completion(.success(tagList))
                        }
                        
                        else if case .fetchCommunitySnap = self {
                            let snap = try JSONDecoder().decode(CommonResponseDtoListFindSnapPagingResDto.self, from: data)
                            completion(.success(snap))
                        }
                        
                        else if case .fetchSnap = self {
                            let snap = try JSONDecoder().decode(CommonResponseDtoFindSnapResDto.self, from: data)
                            completion(.success(snap))
                        }
                        
                        else if case .fetchUserInfo = self {
                            let profileInfo = try JSONDecoder().decode(CommonResponseDtoUserResDto.self, from: data)
                            completion(.success(profileInfo))
                        }
                        
                        else if case .fetchSnapPreview = self {
                            let snapPreview = try JSONDecoder().decode(CommonResponseDtoFindAlbumResDto.self, from: data)
                            completion(.success(snapPreview))
                        }
                        
                        else if case .fetchAlbumList = self {
                            let albumList = try JSONDecoder().decode(CommonResponseDtoListFindAllAlbumsResDto.self, from: data)
                            completion(.success(albumList))
                        }
                        
                        else if case .fetchFollow = self {
                            let friendList = try JSONDecoder().decode(CommonResponseDtoListFindFriendResDto.self, from: data)
                            completion(.success(friendList))
                        }
                        
                        else if case .postFollow = self {
                            completion(.success(data))
                        }
                        
                        else if case .deleteFollowing = self {
                            let result = try JSONDecoder().decode(CommonResDtoVoid.self, from: data)
                            completion(.success(result))
                        }
                        
                        else if case .postReply = self {
                            completion(.success(data))
                        }
                        
                        else {
                            completion(.success(data))
                        }
                    }
                    catch {
                        completion(.failure(FetchError.jsonDecodeError))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                
            }
    }
    
    // MARK: - 이미지 네트워킹 메서드
    static func loadImage(data: String, imageView: UIImageView) {
        if let url = URL(string: data),
            let token = TokenUtils().read(APIService.baseURL, account: "accessToken") {
            print(url)
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("*/*", forHTTPHeaderField: "accept")
                r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                return r
            }
            
            imageView.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                switch result {
                case .success(_):
                    print("success fetch image")
                case .failure(let error):
                    print("error")
                    print(error)
                }
            }
        }
    }
    
    // MARK: - 토큰 없을 때 이미지 네트워킹 메서드
    static func loadImageNonToken(data: String, imageView: UIImageView) {
        guard let url = URL(string: data)  else { return }
        
        let backgroundQueue = DispatchQueue(label: "background_queue",qos: .background)
        
        backgroundQueue.async {
            guard let data = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }
    }
}
