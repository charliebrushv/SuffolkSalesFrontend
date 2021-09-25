//
//  TypeCollectionViewCell.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 6/15/21.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    var typeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        typeLabel = UILabel()
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        typeLabel.font = .systemFont(ofSize: 18)
        typeLabel.textAlignment = .center
        typeLabel.textColor = .white
        contentView.addSubview(typeLabel)
      //  contentView.backgroundColor = .lightGray
        contentView.layer.cornerRadius = 15
        
        typeLabel.snp.makeConstraints{ make in
            make.center.equalToSuperview()
        }
    }
    
    func configure(for type: Type) {
        typeLabel.text = type.type.rawValue
        contentView.backgroundColor = .appColor
        if type.isOn==true {
            contentView.backgroundColor = .lightAppColor
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
