//
//  DriveTableViewCell.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 6/26/21.
//

import UIKit

class DriveTableViewCell: AnyTableViewCell {
    
    let editButton = UIButton()
    
//    var edit: () -> () = {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = .systemFont(ofSize: 15)
        desc.numberOfLines = 3
        desc.textColor = .black
        desc.backgroundColor = .white
        contentView.addSubview(desc)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(systemName: "line.horizontal.3", withConfiguration: config), for: .normal)
        editButton.backgroundColor = .white
        editButton.tintColor = .appColor
//        editButton.addTarget(self, action: #selector(editTap), for: .touchDown)
        contentView.addSubview(editButton)
        
        
        constraints()
    }
    
    func constraints() {
        let padding: CGFloat = 20
        let height: CGFloat = 25
        
        editButton.snp.makeConstraints{ make in
            make.top.equalTo(date.snp.bottom).offset(padding/2)
            make.trailing.equalToSuperview().offset(-padding)
            make.height.width.equalTo(height*1.5)
            
        }
        
        desc.snp.makeConstraints{make in
            make.top.equalTo(time.snp.bottom).offset(padding/2)
            make.leading.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().offset(-padding)
            make.trailing.equalTo(editButton.snp.leading).offset(-padding)
        }
        
    }
//
//    func configure(for sale: Sale, edit: @escaping (() -> ())) {
//        super.configure(for: sale)
//        self.edit = edit
//    }
//
//    @objc func editTap() {
//        edit()
//    }
//    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
