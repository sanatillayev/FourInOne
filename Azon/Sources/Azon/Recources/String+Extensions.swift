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
    func toDateComponents(date: Gregorian) -> DateComponents {
        let pattern = #"(\d{2}):(\d{2})\(\+\d{2}\)"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        
        guard let match = matches.first else {
            return DateComponents()
        }
        
        let hourRange = Range(match.range(at: 1), in: self)
        let minuteRange = Range(match.range(at: 2), in: self)
        
        guard let hourString = hourRange.flatMap({ String(self[$0]) }),
              let minuteString = minuteRange.flatMap({ String(self[$0]) }),
              let hour = Int(hourString),
              let minute = Int(minuteString) else {
            return DateComponents()
        }

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.day = Int(date.day) ?? 0
        dateComponents.month = date.month.number
        dateComponents.year = Int(date.year) ?? 0
        
        return dateComponents
    }
}

extension String {
    func extractTime() -> String {
        guard self.count >= 5 else { return self }
        return String(self.prefix(5))
    }
}
