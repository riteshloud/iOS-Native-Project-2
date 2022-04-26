//
//  ConfigDataObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class ConfigDataObject: NSObject, Codable {
    var arrCountryCodes: [CountryCodeObject] = []
    var arrCurrency: [CurrencyObject] = []
    var arrTimeZones: [TimeZoneObject] = []
    
    init(_ dictionary: [String: Any]) {
        //COUNTRY CODE LIST
        if let countrycodes = dictionary["countrycodes"] as? [Dictionary<String, Any>] {
            for i in 0..<countrycodes.count  {
                let objCountry = CountryCodeObject.init(countrycodes[i])
                self.arrCountryCodes.append(objCountry)
            }
        }
        
        //CURRENCY LIST
        if let currency = dictionary["currency"] as? [Dictionary<String, Any>] {
            for i in 0..<currency.count  {
                let objCurrency = CurrencyObject.init(currency[i])
                self.arrCurrency.append(objCurrency)
            }
        }
        
        //TIMEZONE LIST
        if let timezones = dictionary["timezones"] as? [Dictionary<String, Any>] {
            for i in 0..<timezones.count  {
                let objTimeZone = TimeZoneObject.init(timezones[i])
                self.arrTimeZones.append(objTimeZone)
            }
        }
    }
}

//MARK:- COUNTRY CODE OBJECT
struct CountryCodeObject: Codable {
    var id: Int = 0
    var code: String = ""
    var name: String = ""
    var status: Int = 0
    var created_at: String = ""
    var updated_at: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.code = dictionary["code"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.status = dictionary["status"] as? Int ?? 0
        self.created_at = dictionary["created_at"] as? String ?? ""
        self.updated_at = dictionary["updated_at"] as? String ?? ""
    }
}

//MARK:- CURRENCY OBJECT
struct CurrencyObject: Codable {
    var id: Int = 0
    var country: String = ""
    var currency: String = ""
    var code: String = ""
    var symbol: String = ""
    var created_at: String  = ""
    var updated_at: String  = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.country = dictionary["country"] as? String ?? ""
        self.currency = dictionary["currency"] as? String ?? ""
        self.code = dictionary["code"] as? String ?? ""
        self.symbol = dictionary["symbol"] as? String ?? ""
        self.created_at = dictionary["created_at"] as? String ?? ""
        self.updated_at = dictionary["updated_at"] as? String ?? ""
    }
}

//MARK:- TIMEZONE OBJECT
struct TimeZoneObject: Codable {
    var name: String = ""
    var value: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.value = dictionary["value"] as? String ?? ""
    }
}
