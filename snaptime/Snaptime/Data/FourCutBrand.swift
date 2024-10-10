//
//  FourCutBrand.swift
//  Snaptime
//
//  Created by Bowon Han on 9/2/24.
//

import Foundation

enum FourCutBrand: String, CaseIterable {
    case harufilm, photosignature, studio808, onepercent
    
    init?(index: Int) {
        switch index {
        case 0: self = .harufilm
        case 1: self = .photosignature
        case 2: self = .studio808
        case 3: self = .onepercent
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .harufilm: return "harufilm"
        case .photosignature: return "photosignature"
        case .studio808: return "studio808"
        case .onepercent: return "onepercent"
        }
    }
    
    func toUIName() -> String {
        switch self {
        case .harufilm: return "하루필름"
        case .photosignature: return "포토시그니처"
        case .studio808: return "Studio808"
        case .onepercent: return "1Percent"
        }
    }
    
    func toImageName() -> String {
        switch self {
        case .harufilm: return "haruBrandImage"
        case .photosignature: return "photoSigBrandImage"
        case .studio808: return "studio808BrandImage"
        case .onepercent: return "1percentBrandImage"
        }
    }
}
