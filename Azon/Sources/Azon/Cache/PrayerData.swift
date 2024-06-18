//
//  PrayerData.swift
//
//
//  Created by Bilol Sanatillayev on 18/06/24.
//

import SwiftData
import Foundation

@Model
public class PrayerData {
    @Attribute(.unique) public var id: String
    public let fajr: String
    public let sunrise: String
    public let dhuhr: String
    public let asr: String
    public let maghrib: String
    public let isha: String
    public let date: String
    
    
    init(fajr: String, sunrise: String, dhuhr: String, asr: String, maghrib: String, isha: String, date: String) {
        self.id = UUID().uuidString
        self.fajr = fajr
        self.sunrise = sunrise
        self.dhuhr = dhuhr
        self.asr = asr
        self.maghrib = maghrib
        self.isha = isha
        self.date = date
    }
    public convenience init(model: Prayer) {
        self.init(fajr: model.timings.Fajr,
                  sunrise: model.timings.Sunrise,
                  dhuhr: model.timings.Dhuhr,
                  asr: model.timings.Asr,
                  maghrib: model.timings.Maghrib,
                  isha: model.timings.Isha,
                  date: model.date.readable
        )
    }
}
