//
//  RegistrationViewController.swift
//  GoSafe
//
//  Created by Thomas H. Sandvik
//  Copyright © 2017 Thomas H. Sandvik. All rights reserved.
//

import UIKit
import MapKit
import BentoMap
import ExpandingMenu

class MapViewController: DPContentViewController {
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var anmeldButton: UIButton!
    @IBOutlet weak var anmeldImage: UIImageView!
    
    fileprivate let registrationPresenter = RegistrationPresenter(DataLoadService: DataLoadService())
    
    fileprivate var registrationsToDisplay = [RegistrationViewData]()// Data to display
    
    static let cellSize: CGFloat = 64
    // Used to make sure the map is nicely padded on the edges, and visible annotations
    // aren't hidden under the navigation bar
    
    static let mapInsets =  UIEdgeInsets(top: cellSize, left: (cellSize / 2), bottom: (cellSize / 2), right: (cellSize / 2))
    
    let mapData = QuadTree<Int, MKMapRect, CLLocationCoordinate2D>.sampleData
   
    var locationManager:CLLocationManager!
    var useFakeData:Bool!
    
    
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
        
        //Test or not
        self.useFakeData = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.useFakeData{
            let zoomRect = mapView.mapRectThatFits(mapData.bentoBox.root, edgePadding: type(of: self).mapInsets)
            mapView.setVisibleMapRect(zoomRect,
                                      edgePadding: type(of: self).mapInsets,
                                      animated: false)
        }
        
    }
    
    private func setUpView(){
        self.configureExpandingMenuButton()
        self.headlineLabel.text = NSLocalizedString("RegistreringOverskrift", comment: "")
    }
    
    fileprivate func configureExpandingMenuButton() {
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "chooser-button-tab")!, centerHighlightedImage: UIImage(named: "chooser-button-tab-highlighted")!)
     
        menuButton.center = CGPoint(x: self.view.bounds.width - 30.0, y: self.view.bounds.height - 50.0)
        self.view.addSubview(menuButton)
        
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "Gruppe af mennesker", image: UIImage(named: "chooser-moment-icon-music")!, highlightedImage: UIImage(named: "chooser-moment-icon-place-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.showAnmeld(item: "Music")
        }
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "Enkeltperson", image: UIImage(named: "chooser-moment-icon-place")!, highlightedImage: UIImage(named: "chooser-moment-icon-place-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.showAnmeld(item: "Place")
        }
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "Det er øde", image: UIImage(named: "chooser-moment-icon-camera")!, highlightedImage: UIImage(named: "chooser-moment-icon-camera-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.showAnmeld(item: "Camera")
        }
        
        let item4 = ExpandingMenuItem(size: menuButtonSize, title: "Der er mørkt", image: UIImage(named: "chooser-moment-icon-thought")!, highlightedImage: UIImage(named: "chooser-moment-icon-thought-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.showAnmeld(item: "Thought")
        }
        
        let item5 = ExpandingMenuItem(size: menuButtonSize, title: "Føler mig udsat", image: UIImage(named: "chooser-moment-icon-sleep")!, highlightedImage: UIImage(named: "chooser-moment-icon-sleep-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.showAnmeld(item: "etststs")
        }
        
        menuButton.addMenuItems([item1, item2, item3, item4, item5])
        menuButton.allowSounds = false
        
        menuButton.willPresentMenuItems = { (menu) -> Void in
            print("MenuItems will present.")
        }
        
        menuButton.didDismissMenuItems = { (menu) -> Void in
            print("MenuItems dismissed.")
        }
    }
    
    func showAnmeld(item: String) {
        if item == "Camera"{
            self.takePhoto()
            return
        }
        self.dismissAnmeld(dismiss: false)
    }
    
    func dismissAnmeld(dismiss :Bool){
        if !dismiss{
            self.anmeldButton.fadeIn(duration: animationSpeed, value: 1.0)
            self.anmeldImage.fadeIn(duration: animationSpeed, value: 1.0)
            self.headlineLabel.fadeIn(duration: animationSpeed, value: 1.0)
        }else{
            self.anmeldButton.fadeOut(duration: animationSpeed)
            self.anmeldImage.fadeOut(duration: animationSpeed)
            self.headlineLabel.fadeOut(duration: animationSpeed)
        }
    }
    
    func takePhoto() {
        var imagePicker: UIImagePickerController!
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func openRegistrationAction(sender: UIButton?) {
        self.openRegistration(registrationViewData: nil)
    }
    
    @IBAction func locateMe(_ sender:UIButton!){
        let status:CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.setCenterCoordinate(mapView.userLocation.coordinate, zoomLevel: 14,animated: true)
        }        
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

extension MapViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        // Do something with image
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        view.addSubview(imageView)
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }

}

extension MapViewController : UINavigationControllerDelegate{

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
    @IBAction func anmeld(_ sender: Any) {
        self.anmeldButton.jumpBtn(4.0, jump2: 4.0)
        
        self.dismissAnmeld(dismiss: true)
        // Call backend and push object
        let alert = UIAlertController(title: "Anmeldt!!!", message: "Din registrering er klar!!!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func geoCode(location : CLLocation!){
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                
                let addressDict : [NSString:NSObject] = pm!.addressDictionary as! [NSString: NSObject]
                
                print(addressDict)
                let addrList = addressDict["FormattedAddressLines"] as! [String]
                self.headlineLabel.text = addrList.joined(separator: ",")
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
        
    }

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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}
