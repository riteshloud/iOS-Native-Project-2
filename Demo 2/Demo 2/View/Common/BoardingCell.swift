//
//  BoardingCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 11/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class BoardingCell: UICollectionViewCell {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblTitleCenterYConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Constants.DeviceType.IS_IPHONE_5 {
            self.lblTitleCenterYConstraint?.constant = 100
        }
//        else if Constants.DeviceType.IS_IPHONE_6 {
//            self.lblTitleCenterYConstraint?.constant = 135
//        }
        else if Constants.DeviceType.IS_IPHONE_6P {
            self.lblTitleCenterYConstraint?.constant = 135
        }
        else if Constants.DeviceType.IS_IPHONE_X {
            self.lblTitleCenterYConstraint?.constant = 135
        }
        else if Constants.DeviceType.IS_IPHONE_11_PRO_MAX {
            self.lblTitleCenterYConstraint?.constant = 150
        }
        else if Constants.DeviceType.IS_IPAD {
            
        }
    }
}
