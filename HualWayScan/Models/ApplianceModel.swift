//
//  ApplianceModel.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import Foundation

struct ApplianceModel: Codable, Hashable {
    let id: Int
//    var createAt: Double?
    var barcode: String
    var category: String
    var status: String
    var subStatus: String
    var repairParts: String
    var repairPo: String
    var repairDescription: String
    var repairCost: Int
    var repairRequired: Bool
    var cleaningRequired: Bool
    var recycle: Bool
    var scrap: Bool
    var truckId: String
    
    enum CodingKeys: String, CodingKey {
        case id
//        case createAt = "created_at"
        case barcode
        case category
        case status
        case subStatus = "sub_status"
        case repairParts = "repair_parts"
        case repairPo = "repair_po"
        case repairDescription = "repair_description"
        case repairCost = "repair_cost"
        case repairRequired = "repair_required"
        case cleaningRequired = "cleaning_required"
        case recycle
        case scrap
        case truckId = "truck_id"
    }
}
