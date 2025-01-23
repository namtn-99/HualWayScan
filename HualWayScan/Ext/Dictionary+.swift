//
//  Dictionary.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import Foundation

extension Dictionary {
    func toJSONString() -> String {
        do {
            return String(data: try JSONSerialization.data(withJSONObject: self), encoding: .utf8) ?? ""
        } catch {
            print(error)
            return ""
        }
    }
}
