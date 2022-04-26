//
//  EmployeeSettingsObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 25/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class EmployeeSettingsObject: NSObject {
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var country_code: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.phone = dictionary["phone"] as? String ?? ""
        self.country_code = dictionary["country_code"] as? String ?? ""
    }
}
