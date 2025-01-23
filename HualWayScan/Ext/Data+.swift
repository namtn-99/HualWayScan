//
//  Data+.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import Foundation

extension Data {
    func convertToDictionary() -> [String: Any] {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
            return json ?? [:]
        } catch {
            print(error)
        }
        return [:]
    }
}
