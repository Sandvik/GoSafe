//
//  AddRegistrationControllerViewController.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit
import SwiftValidator

protocol AddRegistrationControllerDelegate: class {
    func refreshData()
}

class AddRegistrationControllerViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMinutesSpend: UITextField!
    @IBOutlet weak var txtProjectName: UITextField!
    
    @IBOutlet weak var txtNameErrorLabel: UILabel!
    @IBOutlet weak var txtMinutesSpendErrorLabel: UILabel!
    @IBOutlet weak var txtProjectNameErrorLabel: UILabel!
    
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    weak var delegate:AddRegistrationControllerDelegate?
    
    let validator = Validator()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    var registrationViewData:RegistrationViewData!
    
    fileprivate let addRegistrationPresenter = AddRegistrationPresenter(DataLoadService: DataLoadService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator?.hidesWhenStopped = true
        /**
         RegistrationViewController attach itself to the presenter. This works because the Controller implements the RegistrationView protocol
         */
        addRegistrationPresenter.attachView(self)
        
        self.setupValidation()
        
        // If Controller is born with data
        if let registrationViewDataTmp = registrationViewData {
            self.headlineLabel.text = NSLocalizedString("RetRegistrering", comment: "")
            self.txtName.text = registrationViewDataTmp.name
            self.txtProjectName.text = registrationViewDataTmp.projectName
            self.txtMinutesSpend.text = registrationViewDataTmp.minutesSpend
        }else{
            self.headlineLabel.text = NSLocalizedString("IndtastRegistrering", comment: "")
        }
        self.cancelBtn.setTitle(NSLocalizedString("ForTrydKnap", comment: ""),for: .normal)
        
        self.txtName.placeholder = NSLocalizedString("Navn", comment: "")
        self.txtProjectName.placeholder = NSLocalizedString("TidForbrugt", comment: "")
        self.txtMinutesSpend.placeholder = NSLocalizedString("ProjektNavn", comment: "")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    /**
     Using a validator framework: https://github.com/jpotts18/SwiftValidator
     */
    private func setupValidation(){
        validator.styleTransformers(success:{ (validationRule) -> Void in
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
                
            }
        }, error:{ (validationError) -> Void in
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 0.5
            }
        })
        
        validator.registerField(txtName, errorLabel: txtNameErrorLabel, rules: [RequiredRule(message:NSLocalizedString("PaakraevetFelt", comment: "")
            ), FullNameRule(message: NSLocalizedString("GyldigtNavn", comment: ""))])
        
        validator.registerField(txtMinutesSpend, errorLabel: txtMinutesSpendErrorLabel, rules: [RequiredRule(message: NSLocalizedString("PaakraevetFelt", comment: "")), FloatRule(message: NSLocalizedString("KunNummer", comment: ""))])
        
        validator.registerField(txtProjectName, errorLabel: txtProjectNameErrorLabel, rules: [RequiredRule(message: NSLocalizedString("PaakraevetFelt", comment: "")), AlphaNumericRule(message: NSLocalizedString("KunGyldigtProjektnavn", comment: ""))])
    }
    
    
    @IBAction func saveData(_ sender: Any) {
        validator.validate(self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

/**
 no complex logic, they are just doing pure view management.
 */
extension AddRegistrationControllerViewController: AddRegistrationView {
    
    func startLoading() {
        activityIndicator?.startAnimating()
    }
    
    func finishLoading() {
        activityIndicator?.stopAnimating()
    }
    
    func setStatus(status: String){
        dismiss(animated: true, completion: {
            self.delegate?.refreshData()
        })
    }
    
    func setEmptyRegistrations() {
        
    }
    
}

extension AddRegistrationControllerViewController{
    
    func keyboardWillShow(notification:Notification) {
        guard let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight.height, 0)
    }
    
    func keyboardWillHide(notification:Notification) {
        scrollView.contentInset = .zero
    }
}

extension AddRegistrationControllerViewController: ValidationDelegate{
    func validationSuccessful() {
        
        let regRegistrationViewData = RegistrationViewData(name: txtName.text!, minutesSpend: txtMinutesSpend.text!, projectName: txtProjectName.text!)
        
        addRegistrationPresenter.setRegistration(registrationViewData: regRegistrationViewData)
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        print("Validation FAILED!")
    }
    
}
