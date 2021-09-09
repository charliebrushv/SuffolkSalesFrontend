//
//  MapViewController.swift
//  YardSaleApp
//
//  Created by Charlie Brush on 6/7/21.
//

import UIKit
import MapKit
import SnapKit
import CoreLocation

protocol MapTableDelegate {
    func newSale(sale: Sale)
    func editOrNot(edit: Bool)
}

protocol MapViewControllerDelegate: AnyObject {
    func setDisplayedAnnotations(annotations: [CustomAnnotation])
    func getUserLocation() -> CLLocation?
    func setTime(time: Time)
    func setAllAnnotations(annotations: [CustomAnnotation])
    func editOrNot(edit: Bool)
}

class MapViewController: UIViewController {
    
    let coordinate = CLLocationCoordinate2D(latitude: 40.72, longitude: -74)
    let geocoder = CLGeocoder()

    let map = MKMapView()
    var region: MKCoordinateRegion!
    var locationManager: CLLocationManager!
    var timePeriod: UISegmentedControl!
    var locateButton: UIButton!
    var addButton: UIButton!
    
    
    var centered: Bool = false
        
    var allAnnotations: [MKAnnotation]? = []
    
 
    
    private var displayedAnnotations: [CustomAnnotation]? = [] {
        willSet {
            if let currentAnnotations = displayedAnnotations {
                map.removeAnnotations(currentAnnotations)
            }
        }
        didSet {
            if let newAnnotations = displayedAnnotations {
                
                map.addAnnotations(newAnnotations)
            }
        }
    }
    
    weak var delegate: navigationControllerDelegate?

    var currentTime: Time = .thisWeek

    
    let alert = UIAlertController(title: "Can't Find Location", message: "Please turn on location services in Settings", preferredStyle: .alert)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: {_ in
            let url = URL(string: UIApplication.openSettingsURLString)
            if let string = url {
                UIApplication.shared.open(string) }
        }))
        
        setUpViews()
        setUpConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //use viewDidAppear so that the alert can be presented
        super.viewDidAppear(animated)
        
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            print("location denied")
            self.present(alert, animated: true, completion: nil)
            print("presenting alert")
        default:
            if !centered {
                map.region.center = locationManager.location!.coordinate
                centered = true
            }
            let myLocation = map.view(for: map.userLocation)
            myLocation?.isUserInteractionEnabled = false
            myLocation?.isEnabled = false
            myLocation?.canShowCallout = false

        }
        
    }
    
    func setUpViews() {
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true
        map.delegate = self
        map.tintColor = .appColor
        view.addSubview(map)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        print(CLLocationManager.locationServicesEnabled())
        if !(CLLocationManager.locationServicesEnabled()) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        
        region = MKCoordinateRegion()
        region.span.latitudeDelta = 0.1
        region.span.longitudeDelta = 0.1
        map.setRegion(region, animated: false)
        
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium, scale: .large)

        locateButton = UIButton()
        locateButton.translatesAutoresizingMaskIntoConstraints = false
        locateButton.setImage(UIImage(systemName: "location", withConfiguration: config), for: .normal)
        locateButton.backgroundColor = .white
        locateButton.tintColor = .appColor
        locateButton.layer.cornerRadius = 30
        locateButton.addTarget(self, action: #selector(locateTapped), for: .touchUpInside)

        map.addSubview(locateButton)
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("New Sale", for: .normal)
        addButton.titleLabel?.numberOfLines = 1
        addButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        addButton.tintColor = .white
        addButton.backgroundColor = .appColor
        addButton.layer.cornerRadius = 30
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        map.addSubview(addButton)


    }


    
    func setUpConstraints() {
        let padding: CGFloat = 20
        let size: CGFloat = 60
        
        map.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        locateButton.snp.makeConstraints{ make in
            make.width.height.equalTo(size)
            make.trailing.bottom.equalToSuperview().offset(-padding)
        }
        
        addButton.snp.makeConstraints{ make in
            make.height.equalTo(size)
            make.width.equalTo(size*2)
            make.leading.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().offset(-padding)
        }
    }
    
    @objc func locateTapped() {
        region.center = map.userLocation.coordinate
        map.setRegion(region, animated: true)
    }
    
    @objc func addTapped() {
        addButton.tintColor = .white
        let newVC = NewSaleViewController()
        newVC.delegate = self.delegate
        newVC.mapTableDelegate = self
        
        geocoder.reverseGeocodeLocation(map.userLocation.location!) {placemarks,_ in
            if let placemark = placemarks?.first {
                newVC.streetField.text = placemark.thoroughfare
                newVC.townField.text = placemark.locality
                newVC.zipField.text = placemark.postalCode
            }
        }
        
        
        self.present(newVC, animated: true, completion: nil)
    }
    
    @objc func addTapping() {
        addButton.tintColor = .gray
    }
}


extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate, MapTableDelegate, MapViewControllerDelegate {
   
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("failure")
//        self.present(alert, animated: true, completion: nil)
//        print("presenting alert 2")
//    }
    
    func newSale(sale: Sale) {
        map.setCenter(sale.getPlacemark()!.coordinate, animated: true)
           
        userDefaults.setValue(sale.id, forKey: "mySale")
        editOrNot(edit: true)
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var view = map.dequeueReusableAnnotationView(withIdentifier: "identifier")
        if view==nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: "identifier")
            view?.canShowCallout = true
        } else {
            view?.annotation = annotation
        }

        let tagImage = UIImage(named: "marker")
        view?.image = tagImage
        view?.frame.size = CGSize(width: 20, height: 30)
        view?.centerOffset = CGPoint(x: 0, y: -15)
        
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.tintColor = .appColor
        view?.rightCalloutAccessoryView = rightButton
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? CustomAnnotation {
            delegate?.presentSaleDetailView(sale: annotation.sale!, view: self, blur: map)
        }
    }
    
    func setDisplayedAnnotations(annotations: [CustomAnnotation]) {
        displayedAnnotations = annotations
    }
    
    func setAllAnnotations(annotations: [CustomAnnotation]) {
        allAnnotations = annotations
    }
    
    func getUserLocation() -> CLLocation? {
        return map.userLocation.location
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        let circle = MKCircle(center: map.userLocation.coordinate, radius: 5)
        if overlay.intersects!(circle.boundingMapRect) {
            renderer.strokeColor = .appColor
        } else {
            renderer.strokeColor = .translucentAppColor
        }
        return renderer
        
    }
    
    func setTime(time: Time) {
        self.currentTime = time
    }
    
    //switches the title of the button to Edit Sale if edit is true else New Sale
    func editOrNot(edit: Bool) {
        if edit {
            addButton.setTitle("Edit Sale", for: .normal)
        } else {
            addButton.setTitle("New Sale", for: .normal)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse {
//            if !centered {
//                map.region.center = locationManager.location!.coordinate
//                centered = true
//            }
            let myLocation = map.view(for: map.userLocation)
            myLocation?.isUserInteractionEnabled = false
            myLocation?.isEnabled = false
            myLocation?.canShowCallout = false
        }
    }

    
}
