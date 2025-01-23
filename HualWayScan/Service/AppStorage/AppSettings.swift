//
//  AppSettings.swift
//  HualWayScan
//
//  Created by NamTrinh on 23/1/25.
//

import Foundation

enum AppSettings {
    @Storage(key: "barcode", defaultValue: "")
    static var barcode: String
}
