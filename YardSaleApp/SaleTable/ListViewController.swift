//
//  ListViewController.swift
//  YardSaleApp
//
//  Created by Charlie Brush on 6/7/21.
//

import UIKit
import SnapKit

protocol ListViewControllerDelegate: AnyObject {
    func setActiveSales(active: [Sale])
    func setFavorites(fav: [Sale])
    func setTime(time: Time)
//    func setSales(sales: [Sale])
}


class ListViewController: UIViewController {
    
    let tableView = UITableView()
    let reuseIdentifier = "saleCellReuse"
    let anyIdentifier = "anyCellReuse"
    
    let empty = UILabel()

    var sales: [Sale] = []
    var activeSales: [Sale] = []
    
    weak var delegate: navigationControllerDelegate?
    var saleDetailView: SaleDetailView!
    let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
    let blurView = UIVisualEffectView()
    
    var favorites: [Sale] = []
    
    var time: Time = .thisWeek
        
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        sales.append(Sale(desc: "Beautiful clothes in size 4 through 10. Gucci bags, Prada shoes, tons of teen clothes. Many items of clothes never worn. Everything must go. Lauren Sambrotto, 12 Ginny Drive.", dateRange: DateRange(startDate: Date(), endDate: Date().advanced(by: 3600)), type: .tag, address: Address(street: "12 Ginny Dr", town: "Shelter Island", zip: "11964")))
        
        setUpViews()
        setUpConstraints()
    }
    
    func setUpViews() {
        activeSales = (delegate?.getActiveSales())!
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
     //   tableView.allowsSelection = false
        tableView.register(SaleTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.register(AnyTableViewCell.self, forCellReuseIdentifier: anyIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.isHidden = false
        view.addSubview(tableView)
        
        
        empty.translatesAutoresizingMaskIntoConstraints = false
        empty.font = .systemFont(ofSize: 20, weight: .regular)
        empty.numberOfLines = 1
        empty.textColor = .gray
        empty.backgroundColor = .white
        empty.isHidden = true
        empty.textAlignment = .center
        empty.text = "No yard sales currently listed"
        view.addSubview(empty)
        
        if activeSales.count==0 {
            empty.isHidden = false
            tableView.isHidden = true
        }
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)

    }
    
    func setUpConstraints() {
        let padding: CGFloat = 10
        let height: CGFloat = 100
        
        tableView.snp.makeConstraints{ make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        empty.snp.makeConstraints{ make in
            make.centerY.equalToSuperview()
            make.height.equalTo(height)
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
        }
    }
    
    @objc func refreshTable() {
        delegate?.refresh {
            self.tableView.refreshControl?.endRefreshing()
        }    
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        activeSales=[]
//        for sale in sales {
//           // for range in sale.dateRange {
//            if delegate!.showDate(date: sale.dateRange.endDate){
//                    activeSales.append(sale)
//                }
//          //  }
//        }
        return activeSales.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if time == .thisWeek {
//            print("anytableviewcell")
            let cell = tableView.dequeueReusableCell(withIdentifier: anyIdentifier, for: indexPath) as! AnyTableViewCell
            let sale = activeSales[indexPath.row]
            cell.configure(for: sale)
            cell.backgroundColor = .white
            return cell
        } else {
//            print("saletableviewcell")
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SaleTableViewCell
            let sale = activeSales[indexPath.row]
            cell.configure(for: sale, isOn: favorites.contains(sale)) {
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
                self.delegate?.setFavorite(sale: sale, withCell: cell)
            }
            cell.backgroundColor = .white
            return cell
        }
    }
}

extension ListViewController: UITableViewDelegate, ListViewControllerDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = (tableView.frame.height/5.5)
        return CGFloat(height)

    }
    
    func setActiveSales(active: [Sale]) {
        self.activeSales = active
        //self.tableView.reloadData()
        empty.isHidden = !(activeSales.count == 0)
        tableView.isHidden = activeSales.count == 0
        
        
//        print("setting active sales")
        self.tableView.reloadData()
        print("listView favorites: \(self.favorites)")
    }
    
//    func setSales(sales: [Sale]) {
//        self.sales
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! SaleTableViewCell

        let selectedSale = activeSales[indexPath.row]
        delegate?.presentSaleDetailView(sale: selectedSale, view: self, blur: tableView)
//        saleDetailView = SaleDetailView(sale: selectedSale) {
////            UIView.animate(withDuration: 0.25) {
////                self.blurView.alpha = 0
////            } completion: { _ in
////                self.blurView.removeFromSuperview()
////            }
//            
//            UIView.animate(withDuration: 0.25) {
//                self.blurView.alpha = 0
//
//                self.saleDetailView.alpha = 0
////                self.saleDetailView.transform = .init(scaleX: 0.5, y: 0.5)
//            } completion: { _ in
//                self.saleDetailView.removeFromSuperview()
//                self.blurView.removeFromSuperview()
//
//            }
//            tableView.isUserInteractionEnabled = true
//
//        }
//        tableView.isUserInteractionEnabled = false
//        
//        blurView.effect = blurEffect
//        blurView.frame = view.frame
//        blurView.alpha = 0
//        view.addSubview(blurView)
//        
//        saleDetailView.alpha = 0
//        view.addSubview(saleDetailView)
//        
//        saleDetailView.snp.makeConstraints{ make in
//            make.center.equalToSuperview()
//            make.height.equalTo(500)
//            make.width.equalTo(300)
//        }
////        UIView.animate(withDuration: 0.25) {
////            self.blurView.alpha=1
////        }
////
//        UIView.animate(withDuration: 0.25) {
////            self.saleDetailView.transform = .init(scaleX: 1.5, y: 1.5)
////            self.saleDetailView.alpha = 1
////            self.saleDetailView.transform = .identity
//            self.blurView.alpha = 1
//            self.saleDetailView.alpha = 1
//        }
    }
    
    func setFavorites(fav: [Sale]) {
        self.favorites = fav
    }
    
    func setTime(time: Time) {
        self.time = time
    }
}
    
