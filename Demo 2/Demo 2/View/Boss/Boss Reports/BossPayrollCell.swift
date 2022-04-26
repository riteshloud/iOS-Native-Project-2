//
//  BossPayrollCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 11/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class BossPayrollCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!    
    @IBOutlet weak var lblEmployeeName: UILabel!
    @IBOutlet weak var lblEmployeeAmount: UILabel!
    
    @IBOutlet weak var vwBottomContent: UIView!
    @IBOutlet weak var lblStraightTitle: UILabel!
    @IBOutlet weak var lblStraightValue: UILabel!
    
    @IBOutlet weak var lblRegularValue: UILabel!
    @IBOutlet weak var lblRegularTitle: UILabel!
    
    @IBOutlet weak var lblLeaveValue: UILabel!
    @IBOutlet weak var lblLeaveTitle: UILabel!
    
    @IBOutlet weak var lblTotalPaidHoursValue: UILabel!
    @IBOutlet weak var lblTotalPaidHoursTitle: UILabel!
    
    @IBOutlet weak var lblOvertimeValue: UILabel!
    @IBOutlet weak var lblOvertimeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.lblStraightTitle.text = "Straight".localized()
        self.lblRegularTitle.text = "Regular".localized()
        self.lblLeaveTitle.text = "Leave".localized()
        self.lblTotalPaidHoursTitle.text = "Total paid hours".localized()
        self.lblOvertimeTitle.text = "Overtime".localized()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
