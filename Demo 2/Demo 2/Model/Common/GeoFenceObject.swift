//
//  GeoFenceObject.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class GeoFenceObject: NSObject, Codable {
    var id: Int = 0
    var name: String = ""
    var radius: Int = 0
    var message: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    init(_ dictionary: [String: Any]) {
        self.id = dictionary["id"] as? Int ?? 0
        self.name = dictionary["name"] as? String ?? ""
        self.radius = dictionary["radius"] as? Int ?? 0
        self.latitude = dictionary["latitude"] as? Double ?? 0.0
        self.longitude = dictionary["longitude"] as? Double ?? 0.0
    }
}
