//
//  MainViewModel.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import SwiftUI
import RxSwift

class MainViewModel: ObservableObject {
    let reposiroty = ApplianceRepository()
    let disposeBag = DisposeBag()
    
    @Published var screenType: UpdateScreenType = .none
    @Published var isError = false
    @Published var errorStr: String?
    @Published var applianceModel: ApplianceModel?
    @Published var isAdded = false
    @Published var isSuccess = false
    @Published var isShowInfoView = false
    @Published var isShowUpdateView = false
    @Published var isExist = false
    
    func postAppliance(code: String) {
        let params = ["barcode" : code]
        reposiroty.postApplication(params)
            .subscribe(onSuccess: { [weak self] response in
                self?.applianceModel = response
                self?.isAdded = true
            }, onFailure: { [weak self] error in
                self?.isExist = true
//                if let error = error as? APIErrorResponse {
//                    self?.errorStr = error.message
//                } else  {
//                    self?.errorStr = error.localizedDescription
//                }
            })
            .disposed(by: disposeBag)
    }
    
    func updateTruckId(code: String, truckId: String) {
        let params = ["barcode" : code, "truck_id": truckId]
        reposiroty.patchApplication(params)
            .subscribe(onSuccess: { [weak self] response in
                self?.applianceModel = response
                self?.isSuccess = true
            }, onFailure: { [weak self] error in
                self?.isError = true
                if let error = error as? APIErrorResponse {
                    self?.errorStr = error.message
                } else  {
                    self?.errorStr = error.localizedDescription
                }
            })
            .disposed(by: disposeBag)
    }
    func getAppliance(code: String) {
        let params = ["appliance_id" : code]
        reposiroty.getApplication(params)
            .subscribe(onSuccess: { [weak self] response in
                self?.applianceModel = response
                if self?.applianceModel?.category.isEmpty ?? true {
                    self?.isShowUpdateView = true
                    return
                }
         
                if self?.applianceModel?.status.isEmpty ?? true {
                    self?.isShowUpdateView = true
                    return
                }
                
                if self?.applianceModel?.status == StatusType.accepted.rawValue {
                    if response?.subStatus == SubStatusType.repair.rawValue {
                        self?.isShowUpdateView = true
                        return
                    } else if response?.subStatus == SubStatusType.testing.rawValue {
                        self?.isShowUpdateView = true
                        return
                    }
                }
                
                if response?.cleaningRequired == true {
                    self?.isShowUpdateView = true
                    return
                }
                
                self?.isShowInfoView = true
            }, onFailure: { [weak self] error in
                self?.isError = true
                if let error = error as? APIErrorResponse {
                    self?.errorStr = error.message
                } else  {
                    self?.errorStr = error.localizedDescription
                }
            })
            .disposed(by: disposeBag)
    }

}
