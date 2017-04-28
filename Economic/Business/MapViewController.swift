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
import BentoMap

class MapViewController: DPContentViewController {
    @IBOutlet var mapView: MKMapView!
    var locationManager:CLLocationManager!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var headlineLabel: UILabel!
    
    fileprivate let registrationPresenter = RegistrationPresenter(registrationService: RegistrationService())
    
    fileprivate var registrationsToDisplay = [RegistrationViewData]()// Data to display
    
    static let cellSize: CGFloat = 64
    // Used to make sure the map is nicely padded on the edges, and visible annotations
    // aren't hidden under the navigation bar
    static let mapInsets =  UIEdgeInsets(top: cellSize, left: (cellSize / 2), bottom: (cellSize / 2), right: (cellSize / 2))
    
    let mapData = QuadTree<Int, MKMapRect, CLLocationCoordinate2D>.sampleData
    
    
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let zoomRect = mapView.mapRectThatFits(mapData.bentoBox.root, edgePadding: type(of: self).mapInsets)
        mapView.setVisibleMapRect(zoomRect,
                                  edgePadding: type(of: self).mapInsets,
                                  animated: false)
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
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
 
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if (userLocation.location == nil){
            return;
        }
        
        mapView.setCenterCoordinate(mapView.userLocation.coordinate, zoomLevel: 14,animated: true)            //setCenterCoordinate
        
    }
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView!
        
        if let single = annotation as? SingleAnnotation {
            annotationView = mapView.dequeueAnnotationView(for: single) as SingleAnnotationView
        }
        else if let cluster = annotation as? ClusterAnnotation {
            annotationView = mapView.dequeueAnnotationView(for: cluster) as ClusterAnnotationView
        }
        //        else {
        //            fatalError("Unexpected annotation type found")
        //            print("Unexpected annotation type found")
        //        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cluster = view as? ClusterAnnotationView, let zoomRect = cluster.typedAnnotation?.root {
            let adjustedZoom = mapView.mapRectThatFits(zoomRect, edgePadding: type(of: self).mapInsets)
            mapView.setVisibleMapRect(adjustedZoom,
                                      edgePadding: type(of: self).mapInsets,
                                      animated: true)
        }
        else {
            view.setSelected(true, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        updateAnnotations(inMapView: mapView,
                          forMapRect: mapView.visibleMapRect)
        
        let location = CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        geoCode(location: location)
    }
    
    
}

private extension MapViewController {
    
    func updateAnnotations(inMapView mapView: MKMapView,
                           forMapRect root: MKMapRect) {
        guard !mapView.frame.isEmpty && !MKMapRectIsEmpty(root) else {
            mapView.removeAnnotations(mapView.annotations)
            return
        }
        let zoomScale = Double(mapView.frame.width) / root.size.width
        let clusterResults = mapData.clusteredDataWithinMapRect(root,
                                                                zoomScale: zoomScale,
                                                                cellSize: Double(MapViewController.cellSize))
        let newAnnotations = clusterResults.map(BaseAnnotation.makeAnnotation)
        
        let oldAnnotations = mapView.annotations.flatMap({ $0 as? BaseAnnotation })
        
        let toRemove = oldAnnotations.filter { annotation in
            return !newAnnotations.contains { newAnnotation in
                return newAnnotation == annotation
            }
        }
        
        let snapshots: [UIView] = toRemove.flatMap { annotation in
            guard let annotationView = mapView.view(for: annotation),
                let snapshot = annotationView.snapshotView(afterScreenUpdates: false),
                mapView.frame.intersects(annotationView.frame) == true else {
                    return nil
            }
            snapshot.frame = annotationView.frame
            mapView.insertSubview(snapshot, aboveSubview: annotationView)
            return snapshot
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            for snapshot in snapshots {
                snapshot.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                snapshot.layer.opacity = 0
            }
        },
                       completion: { _ in
                        for snapshot in snapshots {
                            snapshot.removeFromSuperview()
                        }
        })
        
        mapView.removeAnnotations(toRemove)
        
        let toAdd = newAnnotations.filter { annotation in
            return !oldAnnotations.contains { oldAnnotation in
                return oldAnnotation == annotation
            }
        }
        
        mapView.addAnnotations(toAdd)
    }
    
}
extension MapViewController : CLLocationManagerDelegate {
    
    func geoCode(location : CLLocation!){
        //        /* Only one reverse geocoding can be in progress at a time hence we need to cancel existing
        //         one if we are getting location updates */
        //        geoCoder.cancelGeocode()
        //        geoCoder.reverseGeocodeLocation(location, completionHandler: { (data, error) -&gt; Void in
        //            guard let placeMarks = data as [CLPlacemark]! else {
        //                return
        //            }
        //            let loc: CLPlacemark = placeMarks[0]
        //            let addressDict : [NSString:NSObject] = loc.addressDictionary as! [NSString: NSObject]
        //            let addrList = addressDict["FormattedAddressLines"] as! [String]
        //            let address = ", ".join(addrList)
        //            print(address)
        //            self.address.text = address
        //            self.previousAddress = address
        //        })
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                print(pm!)
                let addressDict : [NSString:NSObject] = pm!.addressDictionary as! [NSString: NSObject]
                let addrList = addressDict["FormattedAddressLines"] as! [String]
                self.headlineLabel.text = "\(addrList)"
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        let location: CLLocation = locations.first!
    //        self.mapView.centerCoordinate = location.coordinate
    //        let reg = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
    //        self.mapView.setRegion(reg, animated: true)
    //        geoCode(location: location)
    //    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
