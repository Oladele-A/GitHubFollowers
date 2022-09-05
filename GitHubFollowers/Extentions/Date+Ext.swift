//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Oladele Abimbola on 8/29/22.
//

import Foundation

extension Date{
    
    func convertToMonthYearFormat() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
