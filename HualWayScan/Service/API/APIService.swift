//
//  APIService.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import Alamofire
import RxSwift
import SVProgressHUD

enum CheckingType {
    case checked
    case unchecked
}

final class APIService {
    static let shared = APIService()
    private let session: Session

    init(_ session: Session = Session.default) {
        self.session = session
//        SVPrgressHUD.setDefaultMaskType(.clear)
//        SVProgressHUD.setBackgroundColor(.clear)
//    
//        SVProgressHUD.setRingThickness(3)
    }

    func request<T: Decodable>(router: APIRouter, checking: CheckingType = .checked) -> Single<T> {
        if checking == .checked {
            SVProgressHUD.show()
            
        }
        return Single<T>.create { singleEvent in
            let request: DataRequest
            request = self.session.request(router)
            
            request.responseString { response in
                print("🌍[API]----Request: \(router.urlRequest?.httpMethod ?? "") " + (router.urlRequest?.url?.absoluteString ?? ""))
                print("[API]----Params: " + (router.params?.toJSONString() ?? ""))
                print("[API]----Response: " + (response.value ?? ""))
            }
            request.responseDecodable(of: T.self) { response in
                if checking == .checked {
                    SVProgressHUD.dismiss()
                }
                self.handleResponse(response, router, checking, singleEvent)
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

extension APIService {
    private func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>,
                                              _ router: APIRouter,
                                              _: CheckingType,
                                              _ singleEvent: @escaping (SingleEvent<T>) -> Void)
    {
        
        let responseDic = response.data?.convertToDictionary()
        let code = responseDic?["code"] as? String
        let message = responseDic?["message"] as? String
    
        switch response.result {
        case let .success(result):
            switch router {
            // Ignore Error
            default:
                if code == "00" || code == nil {
                    singleEvent(.success(result))
                } else {
                    guard let errCode = code,
                          let statusCode = response.response?.statusCode else {
                        return handleError(HttpStatusCode.unknown, nil, message, responseDic, singleEvent)
                    }
                    handleError(HttpStatusCode(rawValue: statusCode) ?? .unknown, errCode, message,
                                responseDic, singleEvent)
                }
              
            }
        case let .failure(errorResponse):
//            switch errorResponse {
//            case .responseSerializationFailed:
//                if T.self == String.self, let data = response.data, let str = String(data: data, encoding: .utf8) {
//                    // swiftlint:disable:next force_cast
//                    singleEvent(.success(str as! T))
//                    return
//                }
//            case .sessionTaskFailed:
//
//                singleEvent(.failure(APIErrorResponse(
//                    code: HttpStatusCode.networkError,
//                    message: "Xin lỗi Quý khách! kết nối đến hệ thống tạm thời gián đoạn. Vui lòng thử lại sau."
//                )))
//                return
//            default:
//                break
//            }
            handleError(errorResponse, code, nil, responseDic, singleEvent)
        }
    }

    private func handleError<T>(
        _ errorResponse: Error,
        _ errCode: String?,
        _ message: String?,
        _ data: [String: Any]?,
        _ singleEvent: @escaping (SingleEvent<T>) -> Void
    ) {
        var error: APIErrorResponse
        error = APIErrorResponse(code: errorResponse as? HttpStatusCode ?? .ok,
                                 message: message ?? "Connection to the system is temporarily interrupted. Please try again later.",
                                 errCode: errCode,
                                 data: data)
//        if let statusCode = (errorResponse as? AFError)?.responseCode {
//            
//            error = APIErrorResponse(code: HttpStatusCode(rawValue: statusCode) ?? .unknown,
//                                     message: "Xin lỗi Quý khách! kết nối đến hệ thống tạm thời gián đoạn. Vui lòng thử lại sau.",
//                                     errCode: errCode)
//        } else {
//            if errCode == "\(HttpStatusCode.unauthorized.rawValue)" {
//                if let vc = UIApplication.keyWindow()?.rootViewController?.topMostViewController() {
//                    vc.showCommonError(content: "Phiên hết hạn. Quý khách vui lòng đăng nhập lại") {
//                        Utils.logOut()
//                        return
//                    }
//                }
//            }
//            error = APIErrorResponse(code: errorResponse as? HttpStatusCode ?? .ok,
//                                     message: message ?? "Xin lỗi Quý khách! kết nối đến hệ thống tạm thời gián đoạn. Vui lòng thử lại sau.",
//                                     errCode: errCode,
//                                     data: data)
//        }
        singleEvent(.failure(error))
    }
}
