//
//  AlertView.swift
//  lect17
//
//  Created by AlexeiPozdnyakov on 14.06.2022.
//

import Foundation
import UIKit

class AlertView: UIView {

    @IBOutlet var centerView: UIView!
    
    @IBAction func didTapCloseAlert() {
        self.removeFromSuperview()
        
    }
}
