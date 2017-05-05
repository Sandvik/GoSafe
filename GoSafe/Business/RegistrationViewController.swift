//
//  RegistrationViewController.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit
import FRDLivelyButton

class RegistrationViewController: DPContentViewController {
    
    @IBOutlet weak var emptyView: UIView?
    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    fileprivate let registrationPresenter = RegistrationPresenter(DataLoadService: DataLoadService())
    
    fileprivate var registrationsToDisplay = [RegistrationViewData]()// Data to display
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView?.register(UINib(nibName: "RegistrationCell", bundle: nil), forCellReuseIdentifier: "RegistrationCell")
        
        activityIndicator?.hidesWhenStopped = true
        
        /**
         RegistrationViewController attach itself to the presenter. This works because the Controller implements the RegistrationView protocol
         */
        registrationPresenter.attachView(self)
        
        registrationPresenter.getRegistrations()// Fetch data
        
        /** View setup */
        self.setUpView()
        
    }
    
    private func setUpView(){
        /** Add plus button */
        let X_Co: CGFloat = UIScreen.main.bounds.size.width / 2
        let Y_Co: CGFloat = UIScreen.main.bounds.size.height - 50
        let button = FRDLivelyButton(frame: CGRect(x: CGFloat(0), y: CGFloat(), width: CGFloat(50), height: CGFloat(50)))
        button.setStyle(kFRDLivelyButtonStyleCirclePlus, animated: false)
        button.addTarget(self, action: #selector(self.openRegistrationAction), for: .touchUpInside)
        button.center = CGPoint(x: X_Co, y: Y_Co)
        
        self.view.addSubview(button)
        
        self.headlineLabel.text = NSLocalizedString("RegistreringOverskrift", comment: "")

    }
    
    @IBAction func openRegistrationAction(sender: UIButton?) {
        self.openRegistration(registrationViewData: nil)
    }
    
    func openRegistration(registrationViewData:RegistrationViewData?){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller:AddRegistrationControllerViewController = storyboard.instantiateViewController(withIdentifier: "AddRegistrationControllerViewController") as! AddRegistrationControllerViewController
        
        controller.registrationViewData = registrationViewData
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    deinit {
        /** perform the deinitialization, but since the presenter has only a weak reference of the View you do not need to call it explicitly. But for clarity reasons I would call it. A good place for it is here:-)
         */
        registrationPresenter.detachView()
    }
    
}

extension RegistrationViewController : AddRegistrationControllerDelegate{
    func refreshData(){
        registrationPresenter.getRegistrations()/** Fetch refreshed data */
    }
}

extension RegistrationViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registrationsToDisplay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RegistrationCell.identifier, for: indexPath) as! RegistrationCell
        
        cell.baseInit(registrationViewData: registrationsToDisplay[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let cell: RegistrationCell = tableView.cellForRow(at: indexPath) as! RegistrationCell
        DispatchQueue.main.asyncAfter(deadline: .now() + animationSpeed) {
            self.openRegistration(registrationViewData: cell.registrationViewData)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return RegistrationCell.getHeight()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return RegistrationCell.getHeight()
    }
    
}

/**
 no complex logic, they are just doing pure view management.
 */
extension RegistrationViewController: RegistrationView {
    
    func startLoading() {
        activityIndicator?.startAnimating()
    }
    
    func finishLoading() {
        activityIndicator?.stopAnimating()
    }
    
    func setRegistrations(_ registrations: [RegistrationViewData]) {
        registrationsToDisplay = registrations
        tableView?.isHidden = false
        emptyView?.isHidden = true;
        tableView?.reloadData()
    }
    
    func setEmptyRegistrations() {
        tableView?.isHidden = true
        emptyView?.isHidden = false;
    }
}
