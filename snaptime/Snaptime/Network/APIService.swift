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
    case postSendEmailCode(email: String)
    case postEmailVerfied(email: String, code: String)
    
    case fetchUserProfile(email: String)
    case fetchUserProfileCount(email: String)
    case fetchUserAlbum(email: String)
    case fetchUserTagSnap(email: String)
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
    case fetchAlarms
    case fetchAlarmSnap(alarmId: Int)
    
    case fetchFollow(type: String, email: String, keyword: String, pageNum: Int)
    case postFollow(email: String)
    case deleteFollowing(email: String)
    
    case postParentReply
    case postChildReply
    case fetchChildReply(pageNum: Int, parentReplyId: Int)
    case fetchParentReply(pageNum: Int, snapId: Int)
    
    case fetchImageFromQR(brand: FourCutBrand, url: String)
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
            
        case .postSendEmailCode(let email):
            "/emails/send?email=\(email)"
            
        case .postEmailVerfied(let email, let code):
            "/emails/verify?email=\(email)&code=\(code)"
            
        case .fetchUserProfile(let email):
            "/profiles/profile?targetEmail=\(email)"
            
        case .fetchUserProfileCount(let email):
            "/profiles/count?email=\(email)"
            
        case .fetchUserAlbum(let email):
            "/profiles/album-snap?targetEmail=\(email)"
            
        case .fetchUserTagSnap(let email):
            "/profiles/tag-snap?email=\(email)"
            
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
            
        case .fetchAlarms:
            "/alarms"
            
        case .fetchAlarmSnap(let alarmId):
            "/alarms/snaps/\(alarmId)"
            
        case .fetchFollow(let type, let email, let keyword, let pageNum):
            "/friends/\(pageNum)?targetEmail=\(email)&friendSearchType=\(type)&searchKeyword=\(keyword)"
            
        case .postFollow(let email):
            "/friends?receiverEmail=\(email)"
            
        case .deleteFollowing(let email):
            "/friends?deletedUserEmail=\(email)"
            
        case .postParentReply:
            "/parent-replies"
            
        case .postChildReply:
            "/child-replies"
            
        case .fetchChildReply(let pageNum, let parentReplyId):
            "/child-replies/\(pageNum)?parentReplyId=\(parentReplyId)"
            
        case .fetchParentReply(let pageNum, let snapId):
            "/parent-replies/\(pageNum)?snapId=\(snapId)"
            
        case .fetchImageFromQR(let brand, let url):
            "/crawler/\(brand.toString())?url=\(url)"
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
            .fetchChildReply,
            .fetchParentReply,
            .fetchImageFromQR,
            .fetchAlarms,
            .fetchAlarmSnap:
                .get
            
        case .modifyUserInfo:
                .patch
            
        case .postParentReply,
            .postChildReply,
            .postFollow,
            .postAlbum,
            .postSignIn,
            .postTestSignIn,
            .postSignUp,
            .postSendEmailCode,
            .postEmailVerfied,
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
            .responseDecodable(of: responseType) { response in
                let statusCode = response.response?.statusCode ?? 0
                
                switch statusCode {
                case 200..<300:
                    switch response.result {
                    case .success(let decodedData):
                        completion(.success(decodedData))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                case 400..<500:
                    // 400대 에러 처리
                    if let data = response.data {
                        do {
                            // CommonMsgRes로 디코딩 시도
                            let errorResponse = try JSONDecoder().decode(CommonMsgRes.self, from: data)
                            let errorMessage = errorResponse.msg
                            let error = NSError(domain: "Bad Request",
                                                code: statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            completion(.failure(error))
                        } catch {
                            // 디코딩 실패 시 일반 에러 처리
                            let errorMessage = String(data: data, encoding: .utf8) ?? "Unknown error"
                            let error = NSError(domain: "Bad Request",
                                                code: statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: errorMessage])
                            completion(.failure(error))
                        }
                    }
                default:
                    // 그 외의 상태 코드 처리
                    let error = NSError(domain: "Unknown Error",
                                        code: statusCode,
                                        userInfo: [NSLocalizedDescriptionKey: "Unexpected error occurred"])
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
