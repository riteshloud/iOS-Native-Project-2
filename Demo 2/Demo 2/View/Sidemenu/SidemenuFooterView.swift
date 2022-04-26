//
//  SidemenuFooterView.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class SidemenuFooterView: UITableViewHeaderFooterView {

    //SUPPORT CENTER
    @IBOutlet weak var vwSupportCenter: UIView!
    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var lblSupportCenter: UILabel!
    @IBOutlet weak var btnSupportCenter: UIButton!
    var onSupportCenterAction: (()->Void)?
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK:- ACTIONS -
    
    @IBAction func btnSupportCenterTapped(_ sender: UIButton) {
        self.onSupportCenterAction?()
    }
}
