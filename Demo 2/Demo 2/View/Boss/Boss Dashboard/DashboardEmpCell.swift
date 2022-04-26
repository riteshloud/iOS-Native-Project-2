//
//  DashboardEmpCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 08/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class DashboardEmpCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
