//
//  SidemenuCell.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class SidemenuCell: UITableViewCell {

    @IBOutlet weak var vwContent: UIView!
    @IBOutlet weak var constraintLeadingOfImageVW: NSLayoutConstraint!
    @IBOutlet weak var imgVwOption: UIImageView!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var lblSeprator: UILabel!
    @IBOutlet weak var constraintBottomOfSeperator: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomOfOption: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
