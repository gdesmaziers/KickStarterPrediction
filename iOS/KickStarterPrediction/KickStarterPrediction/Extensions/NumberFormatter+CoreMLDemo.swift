//
//  NumberFormatter+CoreMLDemo.swift
//  KickStarterPrediction
//
//  Created by Grégory DESMAZIERS on 27/12/2017.
//  Copyright © 2017 Octo Technology. All rights reserved.
//

import Foundation

extension NumberFormatter {
    
    static let dollarFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter
    }()

    
}
