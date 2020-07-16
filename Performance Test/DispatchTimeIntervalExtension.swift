//
//  DispatchTimeIntervalExtension.swift
//  Performance Test
//
//  Created by Djimon Nowak on 15.07.20.
//  Copyright © 2020 Djimon Nowak. All rights reserved.
//

import Foundation
extension DispatchTimeInterval {
    func toDouble() -> Double {
        var result: Double = 0

        switch self {
        case .seconds(let value):
            result = Double(value)*1000000000
        case .milliseconds(let value):
            result = Double(value)*1000000
        case .microseconds(let value):
            result = Double(value)*1000
        case .nanoseconds(let value):
            result = Double(value)
        case .never:
            result = 0.0
        @unknown default:
            result = 0.0
        }

        return result
    }
}
