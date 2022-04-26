//
//  CategoryListObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 16/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class CategoryListObject: NSObject {
    var id: Int = 0
    var company_user_id: Int = 0
    var categoryName: String = ""
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.company_user_id = dictionary["company_user_id"] as? Int ?? 0
        self.categoryName = dictionary["categoryName"] as? String ?? ""
    }
}
