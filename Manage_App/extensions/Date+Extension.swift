//
//  Date+Extension.swift
//  Manage_App
//
//  Created by Pare on 16/9/2566 BE.
//

import Foundation

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
