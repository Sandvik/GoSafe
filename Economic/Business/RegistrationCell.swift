//
//  RegistrationCell.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 08/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit

class RegistrationCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var minutesSpendLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var registrationViewData: RegistrationViewData!
    
    func baseInit(registrationViewData: RegistrationViewData) {
        self.registrationViewData = registrationViewData
        nameLabel.text = registrationViewData.name
        minutesSpendLabel.text = registrationViewData.minutesSpend
        projectNameLabel.text = registrationViewData.projectName
        containerView.applyPlainShadow()
    }
    
    class func getHeight() -> CGFloat {
        return 100
    }

    class var identifier: String {
        return String(describing: RegistrationCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
