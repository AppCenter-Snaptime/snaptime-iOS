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
    case fetchComment(snapId: Int, pageNum: Int)
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
            
        case .fetchComment(_, let pageNum):
            "/parent_replies/\(pageNum)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchUserProfile,
            .fetchUserProfileCount,
            .fetchUserAlbum,
            .fetchCommunitySnap,
            .fetchSnap,
            .fetchComment:
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
        print(url)
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
                                let userProfile = try JSONDecoder().decode(UserProfileModel.self, from: data)
                                UserProfileManager.shared.profile = userProfile
                                completion(.success(userProfile))
                            }
                            
                            else if case .fetchUserProfileCount = self {
                                let userProfileCount = try JSONDecoder().decode(UserProfileCountModel.self, from: data)
                                UserProfileCountManager.shared.profileCount = userProfileCount
                                completion(.success(userProfileCount))
                            }
                            
                            else if case .fetchUserAlbum = self {
                                let userAlbum = try JSONDecoder().decode(UserAlbumModel.self, from: data)
                                UserAlbumManager.shared.userAlbumList = userAlbum
                                completion(.success(userAlbum))
                            }
                            
                            else if case .fetchCommunitySnap = self {
                                let snap = try JSONDecoder().decode(CommunitySnapModel.self, from: data)
                                CommunitySnapManager.shared.snap = snap
                                completion(.success(snap))
                            }
                            
                            else if case .fetchSnap = self {
                                let snap = try JSONDecoder().decode(CommonResponseDtoFindAlbumResDto.self, from: data)
                                
                            }
                            
                            else if case .fetchComment = self {
                                let comment = try JSONDecoder().decode(FindParentReplyResDto.self, from: data)
                                completion(.success(comment))
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
