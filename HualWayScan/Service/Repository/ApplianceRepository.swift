//
//  ApplianceRepository.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import Foundation
import RxSwift

protocol ApplianceRepositoryType {
    func postApplication(_ data: [String: Any]) -> Single<ApplianceModel?>
    func getApplication(_ data: [String: Any]) -> Single<ApplianceModel?>
    func patchApplication(_ data: [String : Any]) -> Single<ApplianceModel?>
}

struct ApplianceRepository: ApplianceRepositoryType {
    let api: APIService = .shared
    
    func postApplication(_ data: [String : Any]) -> Single<ApplianceModel?> {
        let result: Single<BaseResponse<ApplianceModel>> = api.request(router: .postAppliance(params: data))
        return result.map { $0.data }
    }
    
    func getApplication(_ data: [String : Any]) -> Single<ApplianceModel?> {
        let result: Single<ApplianceModel?> = api.request(router: .getApplieance(params: data))
        return result
    }
    
    func patchApplication(_ data: [String : Any]) -> Single<ApplianceModel?> {
        let result: Single<ApplianceModel?> = api.request(router: .patchApplieance(params: data))
        return result
    }
}

struct BaseResponse<T: Codable>: Codable {
    var code: String?
    var data: T?
    var message: String?
}
