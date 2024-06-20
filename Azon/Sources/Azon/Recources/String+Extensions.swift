//
//  File.swift
//  
//
//  Created by Bilol Sanatillayev on 18/06/24.
//

import Foundation

extension String {
    func extractDay() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        guard let date = dateFormatter.date(from: self) else {
            return 0
        }
        
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        
        
        return day
    }
}


extension String {
    func toDateComponents() -> DateComponents {
        var dateComponents = DateComponents()
        
        if let hour = Int(self.prefix(2)) {
            dateComponents.hour = hour
        }
        
        if let range = self.range(of: ":") {
            let minuteStartIndex = self.index(after: range.lowerBound)
            let minuteSubstring = self[minuteStartIndex...]
            
            if let minute = Int(minuteSubstring.prefix(2)) {
                dateComponents.minute = minute
            }
        }
        
        return dateComponents
    }
}

extension String {
    func extractTime() -> String {
        guard self.count >= 5 else { return self }
        return String(self.prefix(5))
    }
}
