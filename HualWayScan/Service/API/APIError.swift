//
//  APIError.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import Foundation

enum HttpStatusCode: Int, Error {
    case ok = 200
    case created = 201
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case notAllowed = 405
    case networkError = 1
    case invalidData = 109
    case unknown

    var localizedMessage: String {
        switch self {
        case .networkError:
            return "No internet"
        default:
            return ""
        }
    }
}

struct APIErrorResponse: Decodable {
    var message: String?
    var code: HttpStatusCode = .ok
    var errCode: String?
    var data: [String: Any]?

    enum CodingKeys: String, CodingKey {
        case code, message, serviceCode
    }

    init(code: HttpStatusCode = .ok, message: String?, errCode: String? = nil, data: [String: Any]? = nil) {
        self.code = code
        self.message = message
        self.errCode = errCode
        self.data = data
    }

    init(from _: Decoder) throws {}

    static func unknownError(debugCode: Int) -> APIErrorResponse {
        return APIErrorResponse(code: .unknown,
                                message: "Something Error")
    }
}

extension APIErrorResponse: LocalizedError {
    public var errorDescription: String? {
        return "Code: \(errCode?.description ?? "nil") - \(message ?? "")"
    }
}

