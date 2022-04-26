//
//  EmployeeTimesheetCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class EmployeeTimesheetCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblPunchInOutTime: UILabel!
    @IBOutlet weak var lblJobCode: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
