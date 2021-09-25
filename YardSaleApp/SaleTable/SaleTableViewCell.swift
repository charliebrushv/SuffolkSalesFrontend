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







