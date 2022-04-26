//
//  Enums.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

enum WebViewCategory: Int {
    case terms
    case privacy
    case help
}

enum Direction: Int {
    case topToBottom = 0
    case bottomToTop
    case leftToRight
    case rightToLeft
}

enum REQUEST : Int {
    case notStarted = 0
    case started
    case failedORNoMoreData
}

enum PayrollType: Int {
    case daily = 0
    case weekly = 1
    case monthly = 2
}

enum PerformerType: Int {
    case weekly = 0
    case monthly = 2
    case alltime = 3
}

enum EmployeeType: Int {
    case active = 0
    case archived = 1
}

enum PackageType: Int {
    case current = 0
    case monthly = 1
}
