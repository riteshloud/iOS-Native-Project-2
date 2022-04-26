//
//  NoPopUpTextField.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class NoPopUpTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool
    {
        if action == #selector(UIResponderStandardEditActions.paste(_:))
        {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
