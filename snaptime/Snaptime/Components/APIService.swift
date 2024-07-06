//
//  APIService.swift
//  Snaptime
//
//  Created by Bowon Han on 5/23/24.
//

import Foundation
import Alamofire

enum FetchError: Error {
    case invalidStatus
    case jsonDecodeError
    case jsonEncodeError
}

enum APIService {
    static let baseURL = "http://na2ru2.me:6308"
    
    case fetchUserProfile(loginId: String)
    case fetchUserProfileCount(loginId: String)
    case fetchUserAlbum(loginId: String)
    case fetchUserInfo
    case modifyUserInfo
    
    case fetchCommunitySnap(pageNum: Int)
    case fetchSnap(albumId: Int)
    case fetchSnapPreview(albumId: Int)
    case fetchAlbumList
    
    case fetchFollow(type: String, loginId: String,keyword: String, pageNum: Int)
    
}

extension APIService {
    var path: String {
        switch self {
        case .fetchUserProfile(let loginId):
            "/users/profile?login_id=\(loginId)"
        
        case .fetchUserProfileCount(let loginId):
            "/users/profile/count?login_id=\(loginId)"
            
        case .fetchUserAlbum(let loginId):
            "/users/album_snap?login_id=\(loginId)"
            
        case .fetchUserInfo:
            "/users"
            
        case .modifyUserInfo:
            "/users"
            
        case .fetchCommunitySnap(let pageNum):
            "/snaps/community/\(pageNum)"
            
        case .fetchSnap(let snapId):
            "/snap/\(snapId)"
            
        case .fetchSnapPreview(let albumId):
            "/album/\(albumId)"
            
        case .fetchAlbumList:
            "/album/albumListWithThumbnail"
            
        case .fetchFollow(let type, let loginId, let keyword, let pageNum):
            "/friends/\(pageNum)?loginId=\(loginId)&friendSearchType=\(type)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUserProfile,
            .fetchUserProfileCount,
            .fetchUserAlbum,
            .fetchCommunitySnap,
            .fetchSnap,
            .fetchUserInfo,
            .fetchSnapPreview,
            .fetchAlbumList,
            .fetchFollow:
                .get
            
        case .modifyUserInfo:
                .put
        }
    }
    
    var url: URL {
        return URL(string: APIService.baseURL + path)!
    }
    
    var headers: HTTPHeaders {
        ["Authorization": ACCESS_TOKEN, "accept": "*/*", "Content-Type": "application/json"]
    }
    
    var request: URLRequest {
        var request = URLRequest(url: url)
        request.method = method
        request.headers = headers
        return request
    }
    
    func performRequest(with parameters: Encodable? = nil, completion: @escaping (Result<Any, Error>) -> Void) {
        print(url)
        
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

        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    guard let data = response.data else { return }
                    
                    do {
                        if case .fetchUserProfile = self {
                            let userProfile = try JSONDecoder().decode(CommonResponseDtoUserProfileResDto.self, from: data)
                            UserProfileManager.shared.profile = userProfile
                            completion(.success(userProfile))
                        }
                        
                        else if case .fetchUserProfileCount = self {
                            let userProfileCount = try JSONDecoder().decode(CommonResponseDtoProfileCntResDto.self, from: data)
                            completion(.success(userProfileCount))
                        }
                        
                        else if case .fetchUserAlbum = self {
                            let userAlbum = try JSONDecoder().decode(CommonResponseDtoListAlbumSnapResDto.self, from: data)
                            UserAlbumManager.shared.userAlbumList = userAlbum
                            completion(.success(userAlbum))
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
                        
                    } catch {
                        completion(.failure(FetchError.jsonDecodeError))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
