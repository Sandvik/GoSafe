//
//  RegistrationViewController.swift
//  Economic
//
//  Created by Thomas H. Sandvik on 12/04/2017.
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit
import FRDLivelyButton
import MenuKit
import MapKit

class MapViewController: DPContentViewController {
    @IBOutlet var mapView: MKMapView!
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    fileprivate let registrationPresenter = RegistrationPresenter(registrationService: RegistrationService())
    
    fileprivate var registrationsToDisplay = [RegistrationViewData]()// Data to display
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        activityIndicator?.hidesWhenStopped = true
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.mapType = MKMapType.standard
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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

extension MapViewController : AddRegistrationControllerDelegate{
    func refreshData(){
        registrationPresenter.getRegistrations()/** Fetch refreshed data */
    }
}


/**
 no complex logic, they are just doing pure view management.
 */
extension MapViewController: RegistrationView {
    
    func startLoading() {
        activityIndicator?.startAnimating()
    }
    
    func finishLoading() {
        activityIndicator?.stopAnimating()
    }
    
    func setRegistrations(_ registrations: [RegistrationViewData]) {
        registrationsToDisplay = registrations
  
    }
    
    func setEmptyRegistrations() {

    }
}


extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if (userLocation.location == nil){
            return;
        }
        
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, zoomLevel: 14,animated: true)            //setCenterCoordinate
        
    }
    
}

extension MapViewController : CLLocationManagerDelegate {
    
}
