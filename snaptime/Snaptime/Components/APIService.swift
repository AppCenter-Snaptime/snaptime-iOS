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
}

enum APIService {
    static let baseURL = "http://na2ru2.me:6308"
    
    case fetchUserProfile(loginId: String)
    case fetchUserProfileCount(loginId: String)
    case fetchUserAlbum(loginId: String)
    case fetchCommunitySnap(pageNum: Int)
    case fetchSnap(albumId: Int)
    case fetchUserInfo
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
            
        case .fetchCommunitySnap(let pageNum):
            "/snaps/community/\(pageNum)"
            
        case .fetchSnap(let albumId):
            "/album/\(albumId)?album_id=\(albumId)"
            
        case .fetchUserInfo:
            "/users"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUserProfile,
            .fetchUserProfileCount,
            .fetchUserAlbum,
            .fetchCommunitySnap,
            .fetchSnap,
            .fetchUserInfo:
                .get
        }
    }
    
    var url: URL {
        return URL(string: APIService.baseURL + path)!
    }
    
    var headers: HTTPHeaders {
        ["Authorization": ACCESS_TOKEN, "accept": "*/*"]
    }
        
    func performRequest(completion: @escaping (Result<Any, Error>) -> Void) {
        AF.request(
                    url,
                    method: method,
                    parameters: nil,
                    encoding: URLEncoding.default,
                    headers: headers
                )
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .success(_):
                        guard let data = response.data else { return }
                        
                        do {
                            if case .fetchUserProfile = self {
                                let userProfile = try JSONDecoder().decode(UserProfileResponse.self, from: data)
                                UserProfileManager.shared.profile = userProfile
                                completion(.success(userProfile))
                            }
                            
                            else if case .fetchUserProfileCount = self {
                                let userProfileCount = try JSONDecoder().decode(UserProfileCountResponse.self, from: data)
                                completion(.success(userProfileCount))
                            }
                            
                            else if case .fetchUserAlbum = self {
                                let userAlbum = try JSONDecoder().decode(UserAlbumResponse.self, from: data)
                                UserAlbumManager.shared.userAlbumList = userAlbum
                                completion(.success(userAlbum))
                            }
                            
                            else if case .fetchCommunitySnap = self {
                                let snap = try JSONDecoder().decode(CommunitySnapResponse.self, from: data)
//                                CommunitySnapManager.shared.snap = snap
                                completion(.success(snap))
                            }
                            
                            else if case .fetchSnap = self {
                                let snap = try JSONDecoder().decode(CommonResponseDtoFindAlbumResDto.self, from: data)
                            }
                            
                            else if case .fetchUserInfo = self {
                                let profileInfo = try JSONDecoder().decode(UserProfileInfoResponse.self, from: data)
                                completion(.success(profileInfo))
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
