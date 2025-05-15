//
//  NumberFormatter + Extensions.swift
//  CatsDogsImageClassififcation
//
//  Created by EKbana on 15/05/2025.
//

import Foundation

extension NumberFormatter {
    static var percent:NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter
    }
}
