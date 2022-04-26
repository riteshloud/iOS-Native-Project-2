//
//  JobOverviewCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class JobOverviewCell: UITableViewCell {

    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblEarning: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.viewContainer.layer.borderColor = UIColor.lightGray.cgColor
        self.viewContainer.layer.borderWidth = 0.3
        
        self.viewContainer.layer.masksToBounds = false
        self.viewContainer.layer.shadowRadius = 1
        self.viewContainer.layer.shadowOpacity = 0.6
        self.viewContainer.layer.shadowColor = UIColor.lightGray.cgColor
        self.viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
