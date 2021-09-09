//
//  PathViewController.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 6/25/21.
//

import UIKit
import SnapKit
import MapKit

protocol PathViewControllerDelegate: AnyObject {
    func setFavorites(fav: [Sale])
    func addFavorite(fav: Sale)
    func removeFavorite(fav: Sale)
}

class PathViewController: UIViewController {
    
    let info = UILabel()
    
    let tableView = UITableView()
    let reuseIdentifier = "cellReuse"
    
    let empty = UILabel()

    var favorites: [Sale] = []
    
    var orderedFavorites: [Sale] = []
    let directions = UIButton()
    
    weak var delegate: navigationControllerDelegate?
    let geocoder = CLGeocoder()
    var routes: [MKRoute] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        views()
        constraints()

    }
    
    
    func views() {
        info.translatesAutoresizingMaskIntoConstraints = false
        info.font = .systemFont(ofSize: 16, weight: .medium)
        info.numberOfLines = 1
        info.textColor = .white
        info.text = "Place starred sales in the order you'd like to visit them"
        info.backgroundColor = .appColor
        info.textAlignment = .center
        view.addSubview(info)
        
        if let fav = delegate?.getFavorites() {
            favorites = fav
        }
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.register(DriveTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.dragInteractionEnabled = true
        tableView.isHidden = false
        tableView.dragDelegate = self
        view.addSubview(tableView)
        
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.font = .systemFont(ofSize: 20, weight: .regular)
        empty.numberOfLines = 3
        empty.textColor = .gray
        empty.backgroundColor = .white
        empty.isHidden = true
        empty.textAlignment = .center
        empty.text = "You do not have any sales starred. Star sales in the Sales tab, and they will show up here."
        view.addSubview(empty)
        
        directions.translatesAutoresizingMaskIntoConstraints = false
        directions.setTitle("Directions", for: .normal)
        directions.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        directions.tintColor = .white
        directions.backgroundColor = .appColor
        directions.layer.cornerRadius = 30
        directions.addTarget(self, action: #selector(directionsTapped), for: .touchUpInside)
        view.addSubview(directions)
        
        if favorites.count==0 {
            directions.isHidden = true
            empty.isHidden = false
            tableView.isHidden = true
        }
    }
    
    func constraints() {
        info.snp.makeConstraints{ make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(30)
        }
        
        let padding: CGFloat = 10
        let height: CGFloat = 100
        
        tableView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(info.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        empty.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.height.equalTo(height)
            make.leading.equalToSuperview().offset(padding*3)
            make.trailing.equalToSuperview().offset(-padding*3)
        }
        
        directions.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-padding)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
    }
    
    @objc func directionsTapped() {
        var urlstring = "comgooglemaps://?daddr="
        var httpstring = "http://maps.google.com/maps?daddr="
        for i in favorites {
            if i==favorites[0] {
                urlstring.append("\(i.lat!),\(i.long!)")
                httpstring.append("\(i.lat!),\(i.long!)")
            } else {
                urlstring.append("+to:\(i.lat!),\(i.long!)")
                httpstring.append("+to:\(i.lat!),\(i.long!)")
            }
        }
        urlstring.append("&directionsmode=driving")
        httpstring.append("&directionsmode=driving")
        let url = URL(string: urlstring)
        guard let string = url else { return }
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            UIApplication.shared.open(string, options: [:], completionHandler: nil)
        } else {
//            let alert = UIAlertController(title: "Can't Find Location", message: "Please turn on location services in Settings", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
//            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: {_ in
//                let url = URL(string: UIApplication.openSettingsURLString)
//                if let string = url {
//                    UIApplication.shared.open(string) }
//            }))
//            self.present(alert, animated: true, completion: nil)
            UIApplication.shared.open(URL(string: httpstring)!, options: [:], completionHandler: nil)
            
//            planRoutes()
        }
    }
//    
//    func planRoutes() {
//        routes = []
//        if let user = userLocation() {
//            let request = MKDirections.Request()
//            request.transportType = .automobile
//            
////            print("favorite count: \(favorites.count)")
//            
//            first(from: user, for: request)
//            if favorites.count>1 {
//                for i in 0...(favorites.count-2) {
//                    if let place1 = self.favorites[i].getPlacemark(), let place2 = self.favorites[i+1].getPlacemark() {
//                        request.source = MKMapItem(placemark: place1)
//                        request.destination = MKMapItem(placemark: place2)
//                        getDirections(for: request)
//                    }
//                }
//            }
//        }
//    }
//    
//    func getDirections(for request: MKDirections.Request) {
//        let directions = MKDirections(request: request)
//        directions.calculate() {response,error in
//            if let route = response?.routes[0] {
//                self.routes.append(route)
//                if self.routes.count==self.favorites.count {
//                    self.delegate?.addPolylines(routes: self.routes)
//                }
//            }
//        }
//    }
//    
//    func first(from user: MKPlacemark, for request: MKDirections.Request) {
//        if let place = self.favorites[0].getPlacemark() {
//            request.source = MKMapItem(placemark: user)
//            request.destination = MKMapItem(placemark: place)
//            getDirections(for: request)
//        }
//    }
//    
//    func last(to user: MKPlacemark, for request: MKDirections.Request) {
//        if let place = self.favorites[favorites.count-1].getPlacemark() {
//            request.source = MKMapItem(placemark: place)
//            request.destination = MKMapItem(placemark: user)
//            getDirections(for: request, last: true)
//        }
//    }
    
    func userLocation() -> MKPlacemark? {
        if let userLoc = delegate?.getUserLocation() {
            let userCoord = CLLocationCoordinate2D(latitude: userLoc.coordinate.latitude, longitude: userLoc.coordinate.longitude)
            return MKPlacemark(coordinate: userCoord)
        } else {
            return nil
        }
    }

}

extension PathViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("favorites \(favorites.count)")
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DriveTableViewCell
        let sale = favorites[indexPath.row]
        cell.configure(for: sale)
        cell.backgroundColor = .white
        return cell
    }
}

extension PathViewController: UITableViewDelegate, PathViewControllerDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (tableView.frame.height/5.5)
        return CGFloat(height)

    }
    
    func setFavorites(fav: [Sale]) {
        favorites=fav
        empty.isHidden = !(fav.count == 0)
        tableView.isHidden = fav.count == 0
        directions.isHidden = fav.count == 0
        tableView.reloadData()
    }
    
    func addFavorite(fav: Sale) {
        favorites.append(fav)
    }
    
    func removeFavorite(fav: Sale) {
        favorites.removeAll() { i in
            i==fav
        }
    }
    
    func moveItem(at source: Int, to dest: Int) {
        guard source != dest else { return }
        
        let fav = favorites[source]
        favorites.remove(at: source)
        favorites.insert(fav, at: dest)
    }
}



extension PathViewController: UITableViewDragDelegate {

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let drag = UIDragItem(itemProvider: NSItemProvider())
        drag.localObject = favorites[indexPath.row]
        return [drag]
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveItem(at: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
}
