//
//  SaleTableViewCell.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 6/12/21.
//

import UIKit

class SaleTableViewCell: AnyTableViewCell {
    
    var starButton: UIButton!
    
    var favorite: () -> () = {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        constraints()
    }
    
    func setup() {
        
        desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = .systemFont(ofSize: 15)
        desc.numberOfLines = 3
        desc.textColor = .black
        desc.backgroundColor = .white
        contentView.addSubview(desc)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
        
        starButton = UIButton()
        starButton.translatesAutoresizingMaskIntoConstraints = false
        starButton.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
        starButton.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .selected)
        starButton.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .highlighted)
        starButton.backgroundColor = .white
        starButton.tintColor = .appColor
        starButton.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
        contentView.addSubview(starButton)
        
    }
    
    func constraints() {
        let padding: CGFloat = 20
        let height: CGFloat = 25
        
        starButton.snp.makeConstraints{ make in
            make.top.equalTo(date.snp.bottom).offset(padding/2)
            make.trailing.equalToSuperview().offset(-padding)
            make.height.width.equalTo(height*1.5)
            
        }
        
        desc.snp.makeConstraints{make in
            make.top.equalTo(time.snp.bottom).offset(padding/2)
            make.leading.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().offset(-padding)
            make.trailing.equalTo(starButton.snp.leading).offset(-padding)
        }
        
    }
    
    func configure(for sale: Sale, isOn: Bool, favorite: @escaping (() -> ())) {
        super.configure(for: sale)
        self.favorite = favorite
        starButton.isSelected = isOn
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected makes the gray line go away
//        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @objc func starTapped() {
        starButton.isSelected = !starButton.isSelected
        favorite()
    }
    
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}












//earlier version of SaleTableViewCell complete (without AnyTableViewCell)


//extension UIButton {
//    open override var isSelected: Bool {
//        willSet {
//            print("selected star")
//        }
//    }
//}


//
//import UIKit
//
//class SaleTableViewCell: UITableViewCell {
//
//    var town: UILabel!
//    var time: UILabel!
//    var date: UILabel!
//    var desc: UILabel!
//    var sale: Sale?
//    var starButton: UIButton!
//
//    var favorite: () -> () = {}
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .white
//
//        setUpViews()
//        setUpConstraints()
//    }
//
//    func setUpViews() {
//
//        town = UILabel()
//        town.translatesAutoresizingMaskIntoConstraints = false
//        town.font = .systemFont(ofSize: 20, weight: .semibold)
//        town.numberOfLines = 1
//        town.textColor = .black
//        town.backgroundColor = .white
//        contentView.addSubview(town)
//
//        time = UILabel()
//        time.translatesAutoresizingMaskIntoConstraints = false
//        time.font = .systemFont(ofSize: 18, weight: .medium)
//        time.numberOfLines = 1
//        time.textColor = .black
//        time.backgroundColor = .white
//        contentView.addSubview(time)
//
//        date = UILabel()
//        date.translatesAutoresizingMaskIntoConstraints = false
//        date.font = .systemFont(ofSize: 20, weight: .semibold)
//        date.numberOfLines = 1
//        date.textColor = .black
//        date.textAlignment = .right
//        date.backgroundColor = .white
//        contentView.addSubview(date)
//
//        desc = UILabel()
//        desc.translatesAutoresizingMaskIntoConstraints = false
//        desc.font = .systemFont(ofSize: 15)
//        desc.numberOfLines = 3
//        desc.textColor = .black
//        desc.backgroundColor = .white
//        contentView.addSubview(desc)
//
//        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
//
//        starButton = UIButton()
//        starButton.translatesAutoresizingMaskIntoConstraints = false
//        starButton.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
//        starButton.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .selected)
//        starButton.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .highlighted)
//        starButton.backgroundColor = .white
//        starButton.tintColor = .appColor
//        starButton.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
//        contentView.addSubview(starButton)
//
//    }
//
//    func setUpConstraints() {
//        let padding: CGFloat = 20
//        let height: CGFloat = 25
//
//        town.snp.makeConstraints{make in
//            make.top.leading.equalToSuperview().offset(padding)
//            make.trailing.equalTo(date.snp.leading).offset(-padding)
//            make.height.equalTo(height)
//        }
//
//        date.snp.makeConstraints{make in
//            make.top.equalToSuperview().offset(padding)
//            make.trailing.equalToSuperview().offset(-padding)
//            make.height.equalTo(height)
//            make.width.equalTo(height*2)
//        }
//
//        time.snp.makeConstraints{make in
//            make.top.equalTo(town.snp.bottom).offset(padding/2)
//            make.leading.equalToSuperview().offset(padding)
//            make.height.equalTo(height)
//            make.trailing.equalToSuperview().offset(-padding)
//        }
//
//        starButton.snp.makeConstraints{ make in
//            make.top.equalTo(date.snp.bottom).offset(padding/2)
//            make.trailing.equalToSuperview().offset(-padding)
//            make.height.width.equalTo(height*1.5)
//
//        }
//
//        desc.snp.makeConstraints{make in
//            make.top.equalTo(time.snp.bottom).offset(padding/2)
//            make.leading.equalToSuperview().offset(padding)
//            make.bottom.equalToSuperview().offset(-padding)
//            make.trailing.equalTo(starButton.snp.leading).offset(-padding)
//        }
//
//    }
//
//    func configure(for sale: Sale, isOn: Bool, favorite: @escaping (() -> ())) {
//        self.sale = sale
//        //add a time, changing based on the navigation button- how do you display multiple dates??
//        town.text = "\(sale.type.rawValue) Sale - \(sale.address.town)"
//        time.text = "\(sale.dateRange.getStartTime())-\(sale.dateRange.getEndTime())"
//        date.text = "\(sale.dateRange.getShortWeekday())."
//        desc.text = sale.desc
//        self.favorite = favorite
//        starButton.isSelected = isOn
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        //super.setSelected makes the gray line go away
////        super.setSelected(selected, animated: animated)
//        // Configure the view for the selected state
//    }
//
//    @objc func starTapped() {
//        starButton.isSelected = !starButton.isSelected
//        favorite()
//    }
//
//
//
//
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
////extension UIButton {
////    open override var isSelected: Bool {
////        willSet {
////            print("selected star")
////        }
////    }
////}
//
