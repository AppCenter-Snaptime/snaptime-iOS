//
//  TabBarItemType.swift
//  snaptime
//
//  Created by Bowon Han on 2/14/24.
//

import Foundation

enum TabBarItemType: String, CaseIterable {
    case home, community, none, profile
    
    // Int형에 맞춰 초기화
    init?(index: Int) {
        switch index {
        case 0: self = .home
        case 1: self = .community
        case 2: self = .none
        case 3: self = .profile
        default: return nil
        }
    }
    
    /// TabBarPage 형을 매칭되는 Int형으로 반환
    func toInt() -> Int {
        switch self {
        case .home: return 0
        case .community: return 1
        case .none: return 2
        case .profile: return 3
        }
    }
    
    /// TabBarPage 형을 매칭되는 한글명으로 변환
    func toKrName() -> String {
        switch self {
        case .home: return "홈"
        case .community: return "커뮤니티"
        case .none: return "미정"
        case .profile: return "프로필"
        }
    }
    
    /// TabBarPage 형을 매칭되는 아이콘명으로 변환
    func toIconName() -> String {
        switch self {
        case .home: return "house"
        case .community: return "magnifyingglass"
        case .none: return "square.text.square"
        case .profile: return "person"
        }
    }
}
