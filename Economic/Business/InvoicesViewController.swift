//
//  InvoicesViewController.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 19/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit
import FRDLivelyButton
import MenuKit

//MARK: Animationshastighed konstant
let animationSpeed = 0.3

class InvoicesViewController: DPContentViewController {
    
    @IBOutlet weak var emptyView: UIView?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var headlineLabel: UILabel!
    
    fileprivate let invoicePresenter = InvoicePresenter(registrationService: RegistrationService())
    
    fileprivate var invoicesToDisplay = [InvoiceViewData]()// Data to display
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView?.register(UINib(nibName: "InvoiceDetailCell", bundle: nil), forCellReuseIdentifier: "InvoiceDetailCell")
        
        activityIndicator?.hidesWhenStopped = true
        
        /*RegistrationViewController attach itself to the presenter. This works because the Controller implements the RegistrationView protocol.*/
        invoicePresenter.attachView(self)
        
        invoicePresenter.getInvoices()// Fetch data
        
        // View setup
        self.setUpView()
        
    }
    
    private func setUpView(){
        // Add plus button
        let X_Co: CGFloat = UIScreen.main.bounds.size.width / 2
        let Y_Co: CGFloat = UIScreen.main.bounds.size.height - 50
        let button = FRDLivelyButton(frame: CGRect(x: CGFloat(0), y: CGFloat(), width: CGFloat(50), height: CGFloat(50)))
        button.setStyle(kFRDLivelyButtonStyleCirclePlus, animated: false)
        button.addTarget(self, action: #selector(self.openRegistrationAction), for: .touchUpInside)
        button.center = CGPoint(x: X_Co, y: Y_Co)
        
        self.view.addSubview(button)
        
        self.headlineLabel.text = NSLocalizedString("Fakturering", comment: "")
    }
    
    @IBAction func openRegistrationAction(sender: UIButton?) {
        self.openInvoice(invoiceViewData: nil)
    }
    
    func openInvoice(invoiceViewData:InvoiceViewData?){
        /**
         TODO: EDIT invoice . Not implemented due to time
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let controller:AddInvoiceControllerViewController = storyboard.instantiateViewController(withIdentifier: "AddInvoiceControllerViewController") as! AddInvoiceControllerViewController
         
         controller.registrationViewData = registrationViewData
         controller.modalPresentationStyle = .overCurrentContext
         present(controller, animated: true, completion: nil)
         */
        
        
        // TODO: Fjernes når impl
        let alert = UIAlertController(title: "Ikke klar!", message: "Nåede ikke til fakturering!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        /** perform the deinitialization, but since the presenter has only a weak reference of the View you do not need to call it explicitly. But for clarity reasons I would call it. A good place for it is here:-)
         */
        invoicePresenter.detachView()
    }
    
}

extension InvoicesViewController: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return invoicesToDisplay.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InvoiceDetailCell.identifier, for: indexPath) as! InvoiceDetailCell
        
        cell.baseInit(invoiceViewData: invoicesToDisplay[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell: InvoiceDetailCell = tableView.cellForRow(at: indexPath) as! InvoiceDetailCell
        DispatchQueue.main.asyncAfter(deadline: .now() + animationSpeed) {
            self.openInvoice(invoiceViewData: cell.invoicesViewData)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return InvoiceDetailCell.getHeight()
    }
    
}
//no complex logic, they are just doing pure view management.
extension InvoicesViewController: InvoiceView {
    
    func startLoading() {
        activityIndicator?.startAnimating()
    }
    
    func finishLoading() {
        activityIndicator?.stopAnimating()
    }
    
    func setInvoices(_ invoices: [InvoiceViewData]) {
        invoicesToDisplay = invoices
        tableView?.isHidden = false
        emptyView?.isHidden = true;
        tableView?.reloadData()
    }
    
    func setEmptyInvoices() {
        tableView?.isHidden = true
        emptyView?.isHidden = false;
    }
}
