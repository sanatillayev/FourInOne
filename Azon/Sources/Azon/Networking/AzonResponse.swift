//
//  AzonResponse.swift
//  
//
//  Created by Bilol Sanatillayev on 16/06/24.
//

import Foundation

struct AzonResponse: Decodable {
    let code: Int
    let status: String
    let data: [Prayer]
}

public struct Prayer: Decodable {
    public let timings: Timing
    public let date: DateModel
}

public struct Timing: Decodable {
    public let Fajr: String
    public let Sunrise: String
    public let Dhuhr: String
    public let Asr: String
    public let Maghrib: String
    public let Isha: String
}

public struct DateModel: Decodable {
    public let readable: String
    public let gregorian: Gregorian
}

public struct Gregorian: Decodable {
    public let date: String
    public let format: String
    public let day: String
    public let month: Month
    public let year: String
}

public struct Month: Decodable {
    public let number: Int
    public let en: String
}

