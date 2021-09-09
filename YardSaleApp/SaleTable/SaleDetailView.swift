//
//  SaleDetailView.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 6/23/21.
//

import UIKit
import SnapKit

class SaleDetailView: UIView {
    
    let type = UILabel()
    let date = UILabel()
    let town = UILabel()
    let street = UILabel()
    let desc = UITextView()
    let starButton = UIButton()
    let directions = UIButton()
    
    let xbutton = UIButton()
    
    var sale: Sale!
    var cancel: () -> ()
    var favorite: () -> ()
    
    init(sale: Sale, isOn: Bool, favorite: @escaping (() -> ()), cancel: @escaping (() -> ())) {
        self.sale = sale
        self.cancel = cancel
        self.favorite = favorite
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 30
        self.starButton.isSelected = isOn
        
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpViews() {
        type.font = .systemFont(ofSize: 25, weight: .semibold)
        type.textColor = .black
        type.text = "\(sale.type.rawValue) Sale"
        addSubview(type)
        
        date.font = .systemFont(ofSize: 20, weight: .medium)
        date.textColor = .black
        date.text = "\(sale.dateRange.getWeekday()) \(sale.dateRange.getStartTime())-\(sale.dateRange.getEndTime())"
        addSubview(date)
        
        town.font = .systemFont(ofSize: 20, weight: .regular)
        town.textColor = .black
        town.text = sale.address.town
        addSubview(town)
        
        street.font = .systemFont(ofSize: 20, weight: .regular)
        street.textColor = .black
        street.text = "\(sale.address.street) \(sale.address.zip)"
        addSubview(street)
        
        desc.font = .systemFont(ofSize: 16, weight: .regular)
        desc.textColor = .black
        desc.isEditable = false
        desc.text = sale.desc
        addSubview(desc)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        
        xbutton.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        xbutton.tintColor = .lightGray
        xbutton.backgroundColor = .white
        xbutton.addTarget(self, action: #selector(xtapped), for: .touchUpInside)
        addSubview(xbutton)
        
        starButton.setImage(UIImage(systemName: "star", withConfiguration: config), for: .normal)
        starButton.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .selected)
        starButton.setImage(UIImage(systemName: "star.fill", withConfiguration: config), for: .highlighted)
        starButton.backgroundColor = .appColor
        starButton.tintColor = .white
        starButton.addTarget(self, action: #selector(starTapped), for: .touchUpInside)
        addSubview(starButton)
        
        type.textColor = .white
        date.textColor = .white
        town.textColor = .white
        street.textColor = .white
        desc.backgroundColor = .appColor
        desc.textColor = .white
        xbutton.backgroundColor = .appColor
        xbutton.tintColor = .white
        backgroundColor = .appColor
//        xbutton.tintColor = .white
        
        directions.translatesAutoresizingMaskIntoConstraints = false
        directions.setTitle("Directions", for: .normal)
        directions.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        directions.tintColor = .appColor
        directions.backgroundColor = .lightAppColor
        directions.layer.cornerRadius = 30
        directions.addTarget(self, action: #selector(directionsTapped), for: .touchUpInside)
        addSubview(directions)
        
    }
    
    func setUpConstraints() {
        let padding: CGFloat = 20
        let offset: CGFloat = 10
        let height: CGFloat = 20
        
        xbutton.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.height.width.equalTo(height*1.5)
        }
        
        starButton.snp.makeConstraints{ make in
            make.top.leading.equalToSuperview().offset(padding)
            make.height.width.equalTo(height*1.5)
            
        }
        
        type.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(padding)
            make.leading.equalTo(starButton.snp.trailing).offset(padding/2)
            make.trailing.equalTo(xbutton.snp.leading).offset(padding)
            make.height.equalTo(height*1.5)
        }
        
        date.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.top.equalTo(type.snp.bottom).offset(offset*2)
            make.height.equalTo(height*1.5)
        }
        
        town.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.top.equalTo(date.snp.bottom).offset(offset*2)
            make.height.equalTo(height)
        }
        
        street.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.top.equalTo(town.snp.bottom).offset(offset)
            make.height.equalTo(height)
        }
        
        directions.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-padding)
            make.width.equalTo(160)
            make.height.equalTo(60)
        }
        
        desc.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(padding)
            make.trailing.bottom.equalToSuperview().offset(-padding)
            make.top.equalTo(street.snp.bottom).offset(offset*2)

        }
    }
    
    @objc func xtapped() {
        cancel()
    }
    
    @objc func starTapped() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        starButton.isSelected = !starButton.isSelected
        favorite()
    }
    
    @objc func directionsTapped() {
        let urlstring = "comgooglemaps://?daddr=\(sale.lat!),\(sale.long!)&directionsmode=driving"
        let url = URL(string: urlstring)
        if let string = url {
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                UIApplication.shared.open(string, options: [:], completionHandler: nil)
            } else if UIApplication.shared.canOpenURL(URL(string: "http://maps.apple.com")!) {
                let urlstring2 = "http://maps.apple.com/?daddr=\(sale.address.street),\(sale.address.town),\(sale.address.zip)&dirflg=d"
                print(urlstring2)
                let url2 = URL(string: urlstring2.replacingOccurrences(of: " ", with: "+"))
                if let string2 = url2 {
                    UIApplication.shared.open(string2, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
