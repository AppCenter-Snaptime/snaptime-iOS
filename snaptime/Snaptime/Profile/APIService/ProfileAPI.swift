//
//  ProfileAPI.swift
//  Snaptime
//
//  Created by Bowon Han on 5/13/24.
//

import Foundation
import Alamofire

enum FetchError: Error {
    case invalidStatus
    case jsonDecodeError
}

enum ProfileAPI {
    static let baseURL = "http://na2ru2.me:6308/users"
    
    case fetchUserProfile(loginId: String)
    case fetchUserProfileCount(loginId: String)
    case fetchUserAlbum(loginId: String)
}

extension ProfileAPI {
    var path: String {
        switch self {
        case .fetchUserProfile(let loginId):
            "/profile?loginId=\(loginId)"
        
        case .fetchUserProfileCount(let loginId):
            "/profile/count?loginId=\(loginId)"
            
        case .fetchUserAlbum(let loginId):
            "/albumSnap?loginId=\(loginId)"
        }
    }
    
    var method: String {
        switch self {
        case .fetchUserProfile,
            .fetchUserProfileCount,
            .fetchUserAlbum:
            "GET"
        }
    }
    
    var url: URL {
        return URL(string: ProfileAPI.baseURL + path)!
    }
    
    var headers: HTTPHeaders {
        ["Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJoeWVvbjAwMDAiLCJ0eXBlIjoiYWNjZXNzIiwicm9sZXMiOlsiUk9MRV9VU0VSIl0sImlhdCI6MTcxNjI2Nzc2NSwiZXhwIjoxNzE2MzU0MTY1fQ.DPkjIuDdfq7D9CvuAgnCbNnMil4pnW9pwE3oNThVfYA", "accept": "*/*"]
    }
        
    func performRequest(completion: @escaping (Result<Any, Error>) -> Void) {
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
                        } catch {
                            completion(.failure(FetchError.jsonDecodeError))
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
    }
}
