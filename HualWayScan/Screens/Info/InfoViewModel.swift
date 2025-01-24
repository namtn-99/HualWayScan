//
//  InfoViewModel.swift
//  HualWayScan
//
//  Created by NamTrinh on 23/1/25.
//

import SwiftUI
import RxSwift

class InfoViewModel: ObservableObject {
    let reposiroty = ApplianceRepository()
    let disposeBag = DisposeBag()
    @Published var isError = false
    @Published var errorStr: String?
    @Published var applianceModel: ApplianceModel?
    
    @Published var selectedCategory: CategoryType = .cooking
    @Published var selectedStatus: StatusType = .accepted
    @Published var selectedSubStatus: SubStatusType? = .condition
    @Published var parts = ""
    @Published var po = ""
    @Published var description = ""
    @Published var cost = ""
    @Published var repairRequired = false
    @Published var cleanRequired = false
    @Published var recycle = false
    @Published var scrap = false
    @Published var isShowSuccess = false
    
    func patchAppliance(barcode: String) {
        let params: [String: Any] = [
            "barcode": barcode,
            "category": selectedCategory.rawValue,
            "status": selectedStatus.rawValue,
            "sub_status": selectedSubStatus?.rawValue ?? "",
            "parts": parts,
            "po": po,
            "description": description,
            "cost": Int(cost) ?? 0,
            "repair_required": repairRequired,
            "clean_required": cleanRequired,
            "recycle": recycle,
        ]
        reposiroty.patchApplication(params)
            .subscribe(onSuccess: { [weak self] response in
                self?.isShowSuccess = true
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
