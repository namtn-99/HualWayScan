//
//  APIRouter.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import Alamofire
import Foundation

enum APIRouter {
    
    case postAppliance(params: [String: Any])
    case getApplieance(params: [String: Any])
    case patchApplieance(params: [String: Any])
    
    var method: HTTPMethod {
        switch self {
        case .postAppliance:
            return .post
        case .patchApplieance:
            return .patch
        default:
            return .get
        }
    }
    
    var url: String {
        switch self {
        default:
            return "https://x8ki-letl-twmt.n7.xano.io/api:jfxYJVwd/"
        }
    }
    
    var path: String {
        switch self {
        case .postAppliance:
            return "appliance"
        case .getApplieance(let params):
            return "appliance/\(params["appliance_id"] ?? "")"
        case .patchApplieance(let params):
            return "appliance/\(params["barcode"] ?? "")"
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .postAppliance(let params):
            return params
        case .patchApplieance(let params):
            return params
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .postAppliance, .patchApplieance:
            return JSONEncoding.default
        default:
            return URLEncoding.queryString
        }
    }
    
    var header: [String: String] {
        let header = ["Content-Type": "application/json; charset=utf-8",
                      "accept": "application/json"]
//        if needAuthorization,
//            let accessToken = KeychainStorage.shared.accessToken {
//            header["Authorization"] = "Bearer \(accessToken)"
//        }
//            
        return header
    }
    
    var needAuthorization: Bool {
        switch self {
        default:
            return false
        }
    }
}

extension APIRouter: URLRequestConvertible {
    func asURLRequest() throws -> URLRequest {
        let url = path.isEmpty ? try url.asURL() : try url.asURL().appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.timeoutInterval = 60
        urlRequest.headers = HTTPHeaders(header)
        urlRequest = try encoding.encode(urlRequest, with: params)
        return urlRequest
    }
}

