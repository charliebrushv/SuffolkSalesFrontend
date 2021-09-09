//
//  Navigation.swift
//  YardSaleApp
//
//  Created by Charlie Brush on 6/12/21.
//
import UIKit
import MapKit


protocol navigationControllerDelegate: AnyObject {
    func showDate(date: Date) -> Bool
//    func setNewSale(sale: Sale)
    func getNewSale() -> Sale?
   // func setPlacemark()
    func getAllSales() -> [Sale]
    func getActiveSales() -> [Sale]
//    func newAnnotation(annotation: CustomAnnotation)
    func presentSaleDetailView(sale: Sale, view: UIViewController, blur: UIView)
    func setFavorite(sale: Sale, withCell: SaleTableViewCell)
    func getFavorites() -> [Sale]
    func getUserLocation() -> CLLocation?
//    func addPolylines(routes: [MKRoute])
    func getTime() -> Time
    func getSales()
    func refresh(done: @escaping () -> ())
//    func setTime(time: Time)
}

class NavigationController: UINavigationController, navigationControllerDelegate {

    
   
    var timePeriod: UISegmentedControl!
    var newSale: Sale?
    var allSales: [Sale] = []
    var activeSales: [Sale] = [] {
        didSet {
            print("active sales count: \(activeSales.count)")
            activeSales.sort() {sale1,sale2 in
                let point1 = CLLocation(latitude: sale1.lat!, longitude: sale1.long!)
                let point2 = CLLocation(latitude: sale2.lat!, longitude: sale2.long!)
                let user = (mapDelegate?.getUserLocation())!
                let dist1 = point1.distance(from: user)
                let dist2 = point2.distance(from: user)
                return dist1<dist2
            }
            
//            print("annotations: \(annotations)")
            var newAnnotations: [CustomAnnotation] = []
            for i in activeSales {
                if let j = annotations[i] {
//                    print("appending annotation")
                    newAnnotations.append(j)
                }
            }
//            print("about to set displayed annotations: \(newAnnotations)")
            mapDelegate?.setDisplayedAnnotations(annotations: newAnnotations)
        }
    }
    
    var favorites: [Sale] = [] {
        didSet {
            listDelegate?.setFavorites(fav: favorites)
//            pathDelegate?.setFavorites(fav: favorites)
            activeFavorites = favorites.filter{sale in showDate(date: sale.dateRange.date)}
        }
    }
    
    var activeFavorites: [Sale] = [] {
        didSet {
            pathDelegate?.setFavorites(fav: activeFavorites)
        }
    }
    
    private var annotations: [Sale:CustomAnnotation] = [:]
//        didSet {
//            if let newAnnotations = annotations {
//                print("setting displayed annotations")
//                mapDelegate?.setDisplayedAnnotations(annotations: newAnnotations)
//            }
//        }
//    }
    
    var listDelegate: ListViewControllerDelegate?
    var mapDelegate: MapViewControllerDelegate?
    var pathDelegate: PathViewControllerDelegate?
    
    let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
//    let blurView = UIVisualEffectView()
//    var saleDetailView: SaleDetailView!
    
    var tab: UITabBarController?
    
    var time: Time = .thisWeek {
        didSet {
            listDelegate?.setTime(time: time)
        }
    }
    
    //a list of all sale ids, updated when getSales is called
    var allSaleIds: [Int] = []
    
    
    //all active sale detail views
    var activeDetailViews: [SaleDetailView] = []
    
    
    init(root: UIViewController) {
        super.init(rootViewController: root)
        if let tabBarController = root as? UITabBarController {
            tab=tabBarController
            tab?.delegate = self
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        navigationBar.barTintColor = .appColor
        
        
        timePeriod = UISegmentedControl()
        timePeriod.translatesAutoresizingMaskIntoConstraints = false
        timePeriod.insertSegment(withTitle: "Today", at: 0, animated: true)
        timePeriod.insertSegment(withTitle: "Tomorrow", at: 1, animated: true)
        timePeriod.insertSegment(withTitle: "This Week", at: 2, animated: true)
        timePeriod.selectedSegmentIndex = 2
        timePeriod.selectedSegmentTintColor = .appColor
        timePeriod.backgroundColor = .lightAppColor
        timePeriod.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        super.navigationBar.addSubview(timePeriod)
        
        timePeriod.snp.makeConstraints{ make in
            make.centerX.centerY.equalToSuperview()
        }
        
        updateActiveSales()
        
        timePeriod.actionForSegment(at: 1)
        
        timePeriod.addTarget(self, action: #selector(updateActiveSales), for: .valueChanged)
        
        getSales()
    }
    
    func getSales() {
        NetworkManager.getSales{ sales in
            self.allSales = sales
            print("getting all sales")
            self.annotations = [:]
            for i in sales {
                let annotation = CustomAnnotation(sale: i, coord: i.getPlacemark()!.coordinate)
//                self.annotations[annotation.sale] = annotation
                self.annotations[i] = annotation
            }
//            self.mapDelegate?.setAllAnnotations(annotations: newAnnotations)
            
            //set all sale ids
            self.allSaleIds = []
            for i in sales {
                self.allSaleIds.append(i.id!)
            }
//            print("all sales \(self.allSales)")
            self.updateFavorites()
            
//            self.updateActiveSales()
            
//            print("favorites \(self.favorites)")
            
            //remove own sale if over
            if let sale = userDefaults.value(forKey: "mySale") as? Int {
                print("sale ids \(self.allSaleIds)")
                if !(self.allSaleIds.contains(sale)) {
                    print("removing")
                    userDefaults.setValue(nil, forKey: "mySale")
                    self.mapDelegate?.editOrNot(edit: false)
                } else {
                    print("not removing")
                    self.mapDelegate?.editOrNot(edit: true)
                }
                print(sale)
            }
        }
        //check what is happening when listDelegate.setActiveSales is called, where do the favorites come from?? clearly they have not been set correctly in the list page, but calling updateActiveSales() somehow fixes that??
    }
    
    //retrieve favorites from userDefaults and set them if they are available
    func updateFavorites() {
//        print("-------")
//        favorites=[]
        if let fav = userDefaults.array(forKey: "favorites") as? [Int] {
//            var mutableFav: [Int] = fav
            var favoriteIds: [Int] = []
            for i in favorites {
                favoriteIds.append(i.id!)
            }
//            print("favorite ids \(favoriteIds)")
//            print("fav \(fav)")
//            print("all sale ids \(allSaleIds)")
            //clear all the favorites before adding new ones
            self.favorites = []
            for i in fav {
                print(allSaleIds.contains(i))
                print(favoriteIds.contains(i))
                //previously this only added favorites that were not already in favoriteIds, now it just adds all
                if allSaleIds.contains(i){
                    NetworkManager.getSale(sale: i) { sale in
                        self.favorites.append(sale)
                        self.updateActiveSales()
                    }
                } else if favoriteIds.contains(i) {
//                    userDefaults.setValue(mutableFav.removeAll() {$0==i}, forKey: "favorites")
                    userDefaults.mutableArrayValue(forKey: "favorites").remove(i)
                }
            }
        }
        
//        print("just updated favorites: \(self.favorites)")
    }
    
    func refresh(done: @escaping () -> ()) {
        getSales()
        done()
    }
    
    @objc func updateActiveSales() {
//        print("update active sales")
        activeSales = allSales.filter {sale in showDate(date: sale.dateRange.date)}
        time = Time(rawValue: timePeriod.selectedSegmentIndex)!
        listDelegate?.setActiveSales(active: activeSales)
        activeFavorites = favorites.filter{sale in showDate(date: sale.dateRange.date)}
        mapDelegate?.setTime(time: time)

    }
    
    func showDate(date: Date) -> Bool {
        let day = 86400.0
        switch timePeriod.selectedSegmentIndex {
        case 0:
            return getRange(start: 0, end: day).contains(date)
        case 1:
            return getRange(start: day, end: day*2).contains(date)
        case 2:
            return getRange(start: 0, end: day*7).contains(date)
        default:
            return true
        }
    }
    
    func getRange(start: Double,end: Double) -> ClosedRange<Date> {
        let date1 = Calendar.current.startOfDay(for: Date()).advanced(by: start)
        let date2 = Calendar.current.startOfDay(for: Date()).advanced(by: end)
        return date1...date2
    }
    
//    func setNewSale(sale: Sale) {
//        getSales()
//        self.newSale = sale
//        let annotation = CustomAnnotation(sale: sale, coord: sale.getPlacemark()!.coordinate)
//        annotations[sale] = annotation
//        allSales.append(sale)
//        updateActiveSales()
//    }
    
    func getNewSale() -> Sale? {
        let sale = newSale
        self.newSale = nil
        return sale
    }
    
//    func setPlacemark() {
//        let index = tabBarController?.selectedIndex
//        let view = tabBarController?.viewControllers?[index!]
//        if index == 0 {
//            tabBarController?.viewControllers?[0].map
//        } else {
//
//        }
//    }
    
    func getAllSales() -> [Sale] {
        return allSales
    }
    
    func getActiveSales() -> [Sale] {
        return activeSales
    }
    
    func presentSaleDetailView(sale: Sale, view: UIViewController, blur: UIView) {
//        if let view = saleDetailView {
//            view.cancel()
//        }
        let blurView = UIVisualEffectView()
        var saleDetailView = UIView()
        saleDetailView = SaleDetailView(sale: sale, isOn: favorites.contains(sale), favorite: {
            self.setFavorite(sale: sale, with: saleDetailView as! SaleDetailView)
        }) {
            UIView.animate(withDuration: 0.25) {
                blurView.alpha = 0
                saleDetailView.alpha = 0
            } completion: { _ in
                saleDetailView.removeFromSuperview()
                blurView.removeFromSuperview()

            }
            blur.isUserInteractionEnabled = true
            if let table = blur as? UITableView {
                table.reloadData()
            }
        }
        blur.isUserInteractionEnabled = false
        
        activeDetailViews.append(saleDetailView as! SaleDetailView)
        
        blurView.effect = blurEffect
        blurView.frame = view.view.frame
        blurView.alpha = 0
        view.view.addSubview(blurView)
        
        saleDetailView.alpha = 0
        view.view.addSubview(saleDetailView)
        
        saleDetailView.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.height.equalTo(500)
            make.width.equalTo(300)
        }

        UIView.animate(withDuration: 0.2) {
            blurView.alpha = 1
            saleDetailView.alpha = 1
        }
    }
    
//    func newAnnotation(sale: Sale) {
//        let annotation = CustomAnnotation(sale: sale, coord: sale.getPlacemark()!.coordinate)
//        annotations[sale] = annotation
//        allSales.append(sale)
//        updateActiveSales()
//    }
    
    func setFavorite(sale: Sale) {
        //if the sale is already favorited, unfavorite it, else favorite it
        if favorites.contains(sale) {
            favorites.removeAll() { i in
                i==sale
            }
            userDefaults.mutableArrayValue(forKey: "favorites").remove(sale.id)
            print(userDefaults.array(forKey: "favorites"))
        } else {
            favorites.append(sale)
            userDefaults.mutableArrayValue(forKey: "favorites").add(sale.id)
            print(userDefaults.array(forKey: "favorites"))
        }
    }
    
    func setFavorite(sale: Sale, with view: SaleDetailView) {
        setFavorite(sale: sale)
        var otherView: SaleDetailView?
        for i in activeDetailViews {
            if i != view && view.sale == i.sale {
                otherView = i
            }
        }
        if let view = otherView {
            view.starButton.isSelected = !view.starButton.isSelected
        }
    }
    
    func setFavorite(sale: Sale, withCell view: SaleTableViewCell) {
        setFavorite(sale: sale)
        var otherView: SaleDetailView?
        for i in activeDetailViews {
            if i != view && view.sale == i.sale {
                otherView = i
            }
        }
        if let other = otherView {
            other.starButton.isSelected = !other.starButton.isSelected
        }
    }
    
    func getFavorites() -> [Sale] {
        return favorites
    }
    
    func getUserLocation() -> CLLocation? {
        return mapDelegate?.getUserLocation()
    }
    
//    func addPolylines(routes: [MKRoute]) {
//        self.tab?.selectedIndex = 0
//        timePeriod.insertSegment(withTitle: "This Week", at: 2, animated: true)
//        mapDelegate?.addPolylines(routes: routes)
//    }
    
    
    
    
}


extension NavigationController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("tabbar selected")
        if tabBarController.selectedIndex==2 {
            if timePeriod.selectedSegmentIndex==2 {
                timePeriod.selectedSegmentIndex=1
                time = .tomorrow
                updateActiveSales()
            }
            timePeriod.removeSegment(at: 2, animated: true)
//            print(timePeriod.selectedSegmentIndex)
        }
            
        if tabBarController.selectedIndex != 2 && timePeriod.numberOfSegments==2 {
            timePeriod.insertSegment(withTitle: "This Week", at: 2, animated: true)
        }
    }
    
    func getTime() -> Time {
        return time
    }
    
//    func setTime(time: Time) {
//        timePeriod.selectedSegmentIndex = time.rawValue
//        self.time = time
//        updateActiveSales()
//    }
}
