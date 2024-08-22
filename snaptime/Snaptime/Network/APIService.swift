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
    
    case postSignIn
    case postSignUp
    case postTestSignIn
    case postReissue
    
    case fetchUserProfile(loginId: String)
    case fetchUserProfileCount(loginId: String)
    case fetchUserAlbum(loginId: String)
    case fetchUserTagSnap(loginId: String)
    case fetchUserInfo
    case modifyUserInfo
    case fetchSearchUserInfo(pageNum: Int, keyword: String)
    case deleteUser(password: String)
    
    case postLikeToggle(snapId: Int)
    case fetchCommunitySnap(pageNum: Int)
    case deleteSnap(snapId: Int)
    case moveSnap(snapId: Int, albumId: Int)
    case fetchSnap(albumId: Int)
    case fetchSnapPreview(albumId: Int)
    case fetchAlbumList
    case postAlbum
    case deleteAlbum(albumId: Int)
    
    case fetchFollow(type: String, loginId: String, keyword: String, pageNum: Int)
    case postFollow(loginId: String)
    case deleteFollowing(loginId: String)
    
    case postReply
    case getChildReply(pageNum: Int, parentReplyId: Int)
    case fetchParentReply(pageNum: Int, snapId: Int)
}

extension APIService {
    var path: String {
        switch self {
            
        case .postReissue:
            "/users/reissue"
            
        case .postSignIn:
            "/users/sign-in"
            
        case .postSignUp:
            "/users/sign-up"
            
        case .postTestSignIn:
            "/users/test/sign-in"
            
        case .fetchUserProfile(let loginId):
            "/profiles/profile?targetLoginId=\(loginId)"
            
        case .fetchUserProfileCount(let loginId):
            "/profiles/count?loginId=\(loginId)"
            
        case .fetchUserAlbum(let loginId):
            "/profiles/album-snap?targetLoginId=\(loginId)"
            
        case .fetchUserTagSnap(let loginId):
            "/profiles/tag-snap?loginId=\(loginId)"
            
        case .fetchUserInfo:
            "/users/my"
            
        case .modifyUserInfo:
            "/users"
            
        case .deleteUser(let password):
            "/users?password=\(password)"
            
        case .fetchSearchUserInfo(let pageNum, let keyword):
            "/users/\(pageNum)?searchKeyword=\(keyword)"
            
        case .postLikeToggle(let snapId):
            "/likes/toggle?snapId=\(snapId)"
            
        case .fetchCommunitySnap(let pageNum):
            "/community/snaps/\(pageNum)"
            
        case .deleteSnap(let snapId):
            "/snap?snapId=\(snapId)"
            
        case .moveSnap(let snapId, let albumId):
            "/snap/album?snapId=\(snapId)&albumId=\(albumId)"
            
        case .fetchSnap(let snapId):
            "/snap/\(snapId)"
            
        case .fetchSnapPreview(let albumId):
            "/album/\(albumId)"
            
        case .fetchAlbumList:
            "/album/albumListWithThumbnail"
            
        case .postAlbum:
            "/album"
            
        case .deleteAlbum(let albumId):
            "/album?albumId=\(albumId)"
            
        case .fetchFollow(let type, let loginId, let keyword, let pageNum):
            "/friends/\(pageNum)?targetLoginId=\(loginId)&friendSearchType=\(type)&searchKeyword=\(keyword)"
            
        case .postFollow(let loginId):
            "/friends?receiverLoginId=\(loginId)"
            
        case .deleteFollowing(let loginId):
            "/friends?deletedUserLoginId=\(loginId)"
            
        case .postReply:
            "/parent-replies"
            
        case .getChildReply(let pageNum, let parentReplyId):
            "/child-replies/\(pageNum)?parentReplyId=\(parentReplyId)"
            
        case .fetchParentReply(let pageNum, let snapId):
            "/parent-replies/\(pageNum)?snapId=\(snapId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUserProfile,
            .fetchUserProfileCount,
            .fetchUserAlbum,
            .fetchUserTagSnap,
            .fetchSearchUserInfo,
            .fetchCommunitySnap,
            .fetchSnap,
            .fetchUserInfo,
            .fetchSnapPreview,
            .fetchAlbumList,
            .fetchFollow,
            .getChildReply,
            .fetchParentReply:
                .get
            
        case .modifyUserInfo:
                .patch
            
        case .postReply,
                .postFollow,
                .postAlbum,
                .postSignIn,
                .postTestSignIn,
                .postSignUp,
                .postLikeToggle,
                .postReissue,
                .moveSnap:
                .post
            
        case .deleteFollowing,
            .deleteAlbum,
            .deleteUser,
            .deleteSnap:
                .delete
        }
    }
    
    var url: URL {
        return URL(string: APIService.baseURL + path)!
    }
    
    var headers: HTTPHeaders {
        /// 로그인, 회원가입 시 토큰 없이 요청 시
        if case .postSignIn = self {
            return ["accept": "*/*", "Content-Type": "application/json"]
        }
        
        else if case .postTestSignIn = self {
            return ["accept": "*/*", "Content-Type": "application/json"]
        }
        
        /// refreshToken으로 accessToken 재발급 시
        else if case .postReissue = self {
            guard let refreshToken = KeyChain.loadAccessToken(key: TokenType.refreshToken.rawValue)
            else {
                return ["accept": "*/*", "Content-Type": "application/json"]
            }
            
            return ["accept": "*/*", "Authorization": "Bearer \(refreshToken)"]
        }
        
        /// 그 외 accessToken으로 접근
        else {
            guard let accessToken = KeyChain.loadAccessToken(key: TokenType.accessToken.rawValue)
            else {
                return ["accept": "*/*", "Content-Type": "application/json"]
            }
            
            return ["Authorization": "Bearer \(accessToken)", "Content-Type": "application/json", "accept": "*/*"]
        }
    }
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        return request
    }
    
    func performRequest<T: Decodable>(
        with parameters: Encodable? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        var request = self.request
        
        if let parameters = parameters {
            do {
                let jsonData = try JSONEncoder().encode(parameters)
                request.httpBody = jsonData
            } catch {
                completion(.failure(FetchError.jsonEncodeError))
                return
            }
        }
        
        AF.request(request, interceptor: APIInterceptor.shared)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let decodedData):
                    completion(.success(decodedData))
                case .failure(let error):
                    print("API 에러입니다.")
                    completion(.failure(error))
                }
            }
        
    }

    // MARK: - 이미지 네트워킹 메서드
    static func loadImage(data: String, imageView: UIImageView) {
        if let url = URL(string: data),
           let token = KeyChain.loadAccessToken(key: TokenType.accessToken.rawValue) {
            let modifier = AnyModifier { request in
                var r = request
                r.setValue("*/*", forHTTPHeaderField: "accept")
                r.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                return r
            }
            
            imageView.kf.setImage(with: url, options: [.requestModifier(modifier)]) { result in
                switch result {
                case .success(_):
                    print("")
                case .failure(let error):
                    print("imageFetchError: \(error)")
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
