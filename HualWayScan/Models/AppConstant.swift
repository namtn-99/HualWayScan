//
//  AppConstant.swift
//  HualWayScan
//
//  Created by NamTrinh on 21/1/25.
//

import Foundation
import SwiftUI

enum AppConstant {
    static let primaryColor = Color(hex: "#EF426F")
    static let secondaryColor = Color(hex: "#00A9E0")
}

enum CategoryType: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case refrigerant = "refrigerant"
    case cooking = "cooking"
    case laundry = "laundry"
    case other = "other"
}

enum StatusType: String, CaseIterable, Identifiable {
    var id: Self { self }
    case accepted
    case rejected
}

enum SubStatusType: String, Identifiable {
    var id: Self { self }
    
    static let accepted: [SubStatusType] = [.testing, .repair, .working]
    static let rejected: [SubStatusType] = [.expensive, .condition, .infested]
    
    /// status: accepted
    case testing
    case repair
    case working
    
    /// stautus: rejected
    case expensive
    case condition
    case infested
}
