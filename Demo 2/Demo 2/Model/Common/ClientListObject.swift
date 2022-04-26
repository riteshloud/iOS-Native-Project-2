//
//  ClientListObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 16/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class ClientListObject: NSObject, Codable {
    var id: Int = 0
    var company_user_id: Int = 0
    var company_name: String = ""
    var client_name: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.company_name = dictionary["company_name"] as? String ?? ""
        self.client_name = dictionary["client_name"] as? String ?? ""
    }
}
