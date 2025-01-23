//
//  HomeViewModel.swift
//  HualWayScan
//
//  Created by NamTrinh on 21/1/25.
//

import SwiftUI
import RxSwift

enum UpdateScreenType {
    case category
    case status
    case none
    
    var title: String {
        switch self {
        case .category:
            return "Update Category"
        case .status:
            return "Update Status"
        case .none:
            return ""
        }
    }
}

class HomeViewModel: ObservableObject {
    let reposiroty = ApplianceRepository()
    let disposeBag = DisposeBag()
    
    @Published var isError = false
    @Published var errorStr: String?
    @Published var applianceModel: ApplianceModel?
    @Published var screenType: UpdateScreenType = .none
    @Published var selectedCategory: CategoryType?
    @Published var selectedStatus: StatusType?
    @Published var selectedSubStatus: SubStatusType?
    @Published var barCode = ""
    @Published var isShowRepairInput = false
    @Published var isShowCleaning = false
    @Published var isShowRepairCompleted = false
    @Published var isShowTesting = false
    @Published var isShowRepairRequired = false
    @Published var isShowInfo = false
    
    var params: [String: Any] = [:]
    
    func getAppliance(code: String) {
        let params = ["appliance_id" : code]
        reposiroty.getApplication(params)
            .subscribe(onSuccess: { [weak self] response in
                self?.applianceModel = response
                if self?.applianceModel?.category.isEmpty ?? true {
                    self?.screenType = .category
                    return
                }
         
                if self?.applianceModel?.status.isEmpty ?? true {
                    self?.screenType = .status
                    return
                }
                
                if self?.applianceModel?.status == StatusType.accepted.rawValue {
                    if response?.subStatus == SubStatusType.repair.rawValue {
                        self?.isShowRepairCompleted.toggle()
                        return
                    } else if response?.subStatus == SubStatusType.testing.rawValue {
                        self?.isShowTesting.toggle()
                        return
                    }
                }
                
                self?.isShowInfo = true
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
    
    func updateCategoryAppliance(code: String) {
        let params: [String: Any] = ["barcode" : code, "category": selectedCategory?.rawValue ?? ""]
        reposiroty.patchApplication(params)
            .subscribe(onSuccess: { [weak self] response in
                self?.applianceModel = response
                if self?.applianceModel?.category.isEmpty ?? true {
                    self?.screenType = .category
                    return
                }
         
                if self?.applianceModel?.status.isEmpty ?? true {
                    self?.screenType = .status
                    return
                }
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
    
    func updateStatus() {
        self.params = [:]
        self.params["barcode"] = barCode
        self.params["status"] = selectedStatus?.rawValue
        self.params["sub_status"] = selectedSubStatus?.rawValue
        
        switch selectedStatus {
        case .rejected:
            if applianceModel?.category == CategoryType.refrigerant.rawValue {
                self.params["recycle"] = true
            } else {
                self.params["scrap"] = true
            }
            patchAppliance()
        case .accepted:
            if selectedSubStatus == .repair {
                params["repair_required"] = true
                self.isShowRepairInput = true
            }
            if selectedSubStatus == .working {
                self.isShowCleaning = true
            }
            if selectedSubStatus == .testing {
                params["sub_status"] = selectedSubStatus?.rawValue ?? ""
                patchAppliance()
            }
        case nil:
            break
        }
    }
    
    func updateRepair(params: [String: Any]) {
        self.params["barcode"] = barCode
        self.params["repair_parts"] = params["repair_parts"]
        self.params["repair_po"] = params["repair_po"]
        self.params["repair_description"] = params["repair_description"]
        self.params["repair_cost"] = params["repair_cost"]
        patchAppliance()
    }
    
    func confirmRepairCompleted(isCompleted: Bool) {
        self.params = [:]
        self.params["barcode"] = barCode
        
        if isCompleted {
            params["repair_required"] = false
            params["sub_status"] = SubStatusType.working.rawValue
            isShowCleaning.toggle()
        } else {
            params["status"] = StatusType.rejected.rawValue
            if applianceModel?.category == CategoryType.refrigerant.rawValue {
                params["recycle"] = true
            } else {
                params["scrap"] = true
            }
            patchAppliance()
        }
    }
    
    func confirmTestingSuccess(isSuccess: Bool) {
        self.params = [:]
        self.params["barcode"] = barCode
        
        if isSuccess {
            params["sub_status"] = SubStatusType.working.rawValue
            isShowCleaning.toggle()
        } else {
            isShowRepairRequired.toggle()
        }
    }
    
    func confirmRepairRequired(isRequired: Bool) {
        self.params["barcode"] = barCode
        
        if isRequired {
            params["repair_required"] = true
            isShowRepairInput.toggle()
        } else {
            params["status"] = StatusType.rejected.rawValue
            if applianceModel?.category == CategoryType.refrigerant.rawValue {
                params["recycle"] = true
            } else {
                params["scrap"] = true
            }
            patchAppliance()
        }
    }
    
    func updateRequireCleaning(isRequire: Bool) {
        self.params["barcode"] = barCode
        self.params["cleaning_required"] = isRequire
        patchAppliance()
    }
    
    func patchAppliance() {
        reposiroty.patchApplication(params)
            .subscribe(onSuccess: { [weak self] response in
                self?.applianceModel = response
                if self?.applianceModel?.category.isEmpty ?? true {
                    self?.screenType = .category
                    return
                }
         
                if self?.applianceModel?.status.isEmpty ?? true {
                    self?.screenType = .status
                    return
                }
                
                if self?.applianceModel?.status == StatusType.accepted.rawValue {
                    if response?.subStatus == SubStatusType.repair.rawValue {
                        self?.isShowRepairCompleted.toggle()
                        return
                    } else if response?.subStatus == SubStatusType.testing.rawValue {
                        self?.isShowTesting.toggle()
                        return
                    }
                }
                
                self?.isShowInfo.toggle()
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
