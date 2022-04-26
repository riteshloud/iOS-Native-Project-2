//
//  UIFontSizeUpdate.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

extension UITextField {
    open override func awakeFromNib() {
        if Constants.DeviceType.IS_IPHONE_5 {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-1)
        }
//        if Constants.DeviceType.IS_IPHONE_6 {
//            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+1)
//        }
        if Constants.DeviceType.IS_IPHONE_6P {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPHONE_X {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+1)
        }
        if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPAD {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+3)
        }
    }
}
extension UITextView {
    open override func awakeFromNib() {
        if Constants.DeviceType.IS_IPHONE_5 {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-1)
        }
//        if Constants.DeviceType.IS_IPHONE_6 {
//            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+1)
//        }
        if Constants.DeviceType.IS_IPHONE_6P {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPHONE_X {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+1)
        }
        if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPAD {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+3)
        }
    }
}
extension UILabel {
    open override func awakeFromNib() {
        if Constants.DeviceType.IS_IPHONE_5 {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!-1)
        }
//        if Constants.DeviceType.IS_IPHONE_6 {
//            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+1)
//        }
        if Constants.DeviceType.IS_IPHONE_6P {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPHONE_X {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+1)
        }
        if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPAD {
            self.font=UIFont(name: (self.font?.fontName)!, size: (self.font?.pointSize)!+3)
        }
    }
}
extension UIButton {
    open override func awakeFromNib() {
        if Constants.DeviceType.IS_IPHONE_5 {
            self.titleLabel?.font=UIFont(name: (self.titleLabel!.font?.fontName)!, size: (self.titleLabel!.font?.pointSize)!-1)
        }
//        if Constants.DeviceType.IS_IPHONE_6 {
//            self.titleLabel?.font=UIFont(name: (self.titleLabel!.font?.fontName)!, size: (self.titleLabel!.font?.pointSize)!+1)
//        }
        if Constants.DeviceType.IS_IPHONE_6P {
            self.titleLabel?.font=UIFont(name: (self.titleLabel!.font?.fontName)!, size: (self.titleLabel!.font?.pointSize)!+2)
        }
        if Constants.DeviceType.IS_IPHONE_X {
            self.titleLabel?.font=UIFont(name: (self.titleLabel!.font?.fontName)!, size: (self.titleLabel!.font?.pointSize)!+1)
        }
        if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
            self.titleLabel?.font=UIFont(name: (self.titleLabel!.font?.fontName)!, size: (self.titleLabel!.font?.pointSize)!+2)
        }
        else if Constants.DeviceType.IS_IPAD {
            self.titleLabel?.font=UIFont(name: (self.titleLabel!.font?.fontName)!, size: (self.titleLabel!.font?.pointSize)!+3)
        }
    }
}
