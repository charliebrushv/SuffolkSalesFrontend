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
//    func addPolylines(routes: [MKRoute])
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
    
//    var removeRoute: UIButton!
    
    var centered: Bool = false
        
    var allAnnotations: [MKAnnotation]? = []
    
 
    
    private var displayedAnnotations: [CustomAnnotation]? = [] {
        willSet {
//            print("willset displayedannotations")
            if let currentAnnotations = displayedAnnotations {
                map.removeAnnotations(currentAnnotations)
            }
            //maybe change this to map.annotations instead of currentAnnotations
        }
        didSet {
            //print(displayedAnnotations?.count)
            if let newAnnotations = displayedAnnotations {
                
                map.addAnnotations(newAnnotations)
//                print(newAnnotations)
            }
        }
    }
    
    weak var delegate: navigationControllerDelegate?
    
//    var todayOverlays: [MKOverlay]?
//    var tomorrowOverlays: [MKOverlay]?
    var currentTime: Time = .thisWeek
//        didSet {
//            map.removeOverlays(map.overlays)
//            switch currentTime {
//            case .today:
//                if let overlays = todayOverlays {
//                    map.addOverlays(overlays)
//                    removeRoute.isHidden = false
//                } else {
//                    removeRoute.isHidden = true
//                }
//            case .tomorrow:
//                if let overlays = tomorrowOverlays {
////                    print("tomorrow overlays")
//                    map.addOverlays(overlays)
//                    removeRoute.isHidden = false
//                } else {
//                    removeRoute.isHidden = true
//                }
//            case .thisWeek:
//                removeRoute.isHidden = true
//            }
//        }
//    }
    
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
        case .denied, .restricted, .notDetermined:
            print("location denied")
            self.present(alert, animated: true, completion: nil)
        default:
//            print("success")
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
       // map.isUserInteractionEnabled = false
        view.addSubview(map)
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        print(CLLocationManager.locationServicesEnabled())
        if !(CLLocationManager.locationServicesEnabled()) {
//            print("location disabled")
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
        //locateButton.addTarget(self, action: #selector(timePeriodTapping), for: .touchDown)
        locateButton.addTarget(self, action: #selector(locateTapped), for: .touchUpInside)

        map.addSubview(locateButton)
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        //addButton.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
//        (userDefaults.value(forKey: "mySale")==nil) ? addButton.setTitle("New Sale", for: .normal) : addButton.setTitle("Edit Sale", for: .normal)
        addButton.setTitle("New Sale", for: .normal)
//        addButton.setTitle("New Sale", for: .normal)
        addButton.titleLabel?.numberOfLines = 1
        addButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        addButton.tintColor = .white
        //addButton.setTitle("New Sale", for: .normal)
       // addButton.titleEdgeInsets = UIEdgeInsets(top: , left: , bottom: , right: )
        addButton.backgroundColor = .appColor
        addButton.layer.cornerRadius = 30
     //   addButton.addTarget(self, action: #selector(addTapping), for: .touchDown)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        map.addSubview(addButton)
        
//        removeRoute = UIButton()
//        removeRoute.isHidden = true
//        removeRoute.translatesAutoresizingMaskIntoConstraints = false
//        removeRoute.setTitle("Remove Route", for: .normal)
//        removeRoute.titleLabel?.numberOfLines = 1
//        removeRoute.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
//        removeRoute.tintColor = .white
//        removeRoute.backgroundColor = .appColor
//        removeRoute.layer.cornerRadius = 15
//        removeRoute.addTarget(self, action: #selector(removeRouteTapped), for: .touchUpInside)
//        map.addSubview(removeRoute)
        
        

        
//        addCustomAnnotation()

    }

    
//    func addCustomAnnotation() {
//        let coord = CLLocationCoordinate2D(latitude: 40.754932,longitude: -73.984016)
////        let pin = CustomAnnotation(title: "title",subtitle: "subtitle",coord: missionDoloresCoor)
////        let pin = MKPointAnnotation()
////        pin.title = "title"
////        pin.subtitle = "subtitle"
////        pin.coordinate = coord
//        let pin = CustomAnnotation(sale: Sale(desc: "Beautiful clothes in size 4 through 10. Gucci bags, Prada shoes, tons of teen clothes. Many items of clothes never worn. Everything must go. Lauren Sambrotto, 12 Ginny Drive.", dateRange: DateRange(date: Date(), endDate: Date().advanced(by: 3600)), type: .tag, address: Address(street: "12 Ginny Dr", town: "Shelter Island", zip: "11964")), coord: coord)
//        map.addAnnotation(pin)
//    }
    
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
        
//        removeRoute.snp.makeConstraints{ make in
//            make.height.equalTo(size/2)
//            make.width.equalTo(size*2)
//            make.trailing.equalToSuperview().offset(-padding)
//            make.top.equalToSuperview().offset(padding)
//        }
    }
    
    @objc func locateTapped() {
        region.center = map.userLocation.coordinate
        map.setRegion(region, animated: true)
     //  map.setCenter(map.userLocation.coordinate, animated: true)
//        map.setCenter(locationManager.location!.coordinate, animated: true)
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
    
//    @objc func removeRouteTapped() {
//        map.removeOverlays(map.overlays)
//        removeRoute.isHidden = true
//        if currentTime == .today {
//            todayOverlays = nil
//        }
//        else if currentTime == .tomorrow {
//            tomorrowOverlays = nil
//        }
//    }


}


extension MapViewController: CLLocationManagerDelegate, MKMapViewDelegate, MapTableDelegate, MapViewControllerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("failure")
        self.present(alert, animated: true, completion: nil)
    }
    
    //adds a new sale
    func newSale(sale: Sale) {
        //this needs to be changed
//        if let sale = delegate?.getNewSale() {
            map.setCenter(sale.getPlacemark()!.coordinate, animated: true)
           
        userDefaults.setValue(sale.id, forKey: "mySale")
        editOrNot(edit: true)
//            let annotation = MKPointAnnotation()
//            annotation.title = sale.address.street
//            annotation.subtitle = sale.address.town
//            annotation.coordinate = sale.getPlacemark()!.coordinate
            
//            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: NSStringFromClass(CustomAnnotation.self))
//
//            allAnnotations?.append(annotation)
//            displayedAnnotations = allAnnotations
//            map.addAnnotation((sale.getPlacemark()!))
        }
//
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let identifier = NSStringFromClass(CustomAnnotation.self)
////        let view = map.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)
//        let view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//
//        view.image = UIImage(systemName: "tag.fill")
//        view.canShowCallout = true
//        view.tintColor = .systemTeal
//        view.markerTintColor = .systemTeal
//        view.animatesWhenAdded = true
////        if let markerAnnotationView = view as? MKMarkerAnnotationView {
////            markerAnnotationView.animatesWhenAdded = true
////            markerAnnotationView.canShowCallout = true
////            markerAnnotationView.markerTintColor = UIColor.systemTeal
////            markerAnnotationView.annotation = annotation
////
////            let rightButton = UIButton(type: .detailDisclosure)
////            markerAnnotationView.rightCalloutAccessoryView = rightButton
////        }
//        return view
//    }

    
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
//
//    func addPolylines(routes: [MKRoute]) {
////        print("route count \(routes.count)")
//        removeRoute.isHidden = false
//        map.removeOverlays(map.overlays)
////        map.addOverlay(route.polyline)
////        map.setCenter(map.userLocation.coordinate, animated: true)
//        var polylines: [MKPolyline] = []
//        for i in routes {
//            polylines.append(i.polyline)
//        }
//        let route = MKMultiPolyline(polylines)
//        map.addOverlays(polylines)
//        let offset: CGFloat = 50
//        let inset = UIEdgeInsets(top: offset, left: offset, bottom: offset, right: offset)
////        map.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: inset, animated: true)
//        map.setVisibleMapRect(route.boundingMapRect, edgePadding: inset, animated: true)
//
//        if currentTime == .today {
//            todayOverlays = map.overlays
//        } else if currentTime == .tomorrow {
//            tomorrowOverlays = map.overlays
//        }
//    }
    
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

    
}
