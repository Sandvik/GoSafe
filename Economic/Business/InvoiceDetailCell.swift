//
//  InvoiceDetailCell.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 20/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit

class InvoiceDetailCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var minutesSpendLabel: UILabel!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    var invoicesViewData: InvoiceViewData!
    
    func baseInit(invoiceViewData: InvoiceViewData) {
        self.invoicesViewData = invoiceViewData
        
        self.headlineLabel.text = NSLocalizedString("Faktura", comment: "")
        nameLabel.text = invoiceViewData.name
        minutesSpendLabel.text = invoiceViewData.minutesSpend
        projectNameLabel.text = invoiceViewData.projectName
        containerView.applyPlainShadow()
    }
    
    class func getHeight() -> CGFloat {
        return 160
    }

    class var identifier: String {
        return String(describing: InvoiceDetailCell.self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
