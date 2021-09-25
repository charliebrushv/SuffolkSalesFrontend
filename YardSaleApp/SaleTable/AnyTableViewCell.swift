//
//  AnyTableViewCell.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 6/26/21.
//


import UIKit

class AnyTableViewCell: UITableViewCell {
    
    var town: UILabel!
    var time: UILabel!
    var date: UILabel!
    var desc: UILabel!
    var sale: Sale?
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        
        setUpViews()
        setUpConstraints()
    }
    
    func setUpViews() {
        
        town = UILabel()
        town.translatesAutoresizingMaskIntoConstraints = false
        town.font = .systemFont(ofSize: 20, weight: .semibold)
        town.numberOfLines = 1
        town.textColor = .black
        town.backgroundColor = .white
        contentView.addSubview(town)
        
        time = UILabel()
        time.translatesAutoresizingMaskIntoConstraints = false
        time.font = .systemFont(ofSize: 18, weight: .medium)
        time.numberOfLines = 1
        time.textColor = .black
        time.backgroundColor = .white
        contentView.addSubview(time)
        
        date = UILabel()
        date.translatesAutoresizingMaskIntoConstraints = false
        date.font = .systemFont(ofSize: 20, weight: .semibold)
        date.numberOfLines = 1
        date.textColor = .black
        date.textAlignment = .right
        date.backgroundColor = .white
        contentView.addSubview(date)
        
        desc = UILabel()
        desc.translatesAutoresizingMaskIntoConstraints = false
        desc.font = .systemFont(ofSize: 15)
        desc.numberOfLines = 3
        desc.textColor = .black
        desc.backgroundColor = .white
        contentView.addSubview(desc)
                
    }
    
    func setUpConstraints() {
        let padding: CGFloat = 20
        let height: CGFloat = 25
        
        town.snp.makeConstraints{make in
            make.top.leading.equalToSuperview().offset(padding)
            make.trailing.equalTo(date.snp.leading).offset(-padding)
            make.height.equalTo(height)
        }
        
        date.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().offset(-padding)
            make.height.equalTo(height)
            make.width.equalTo(height*2)
        }
        
        time.snp.makeConstraints{make in
            make.top.equalTo(town.snp.bottom).offset(padding/2)
            make.leading.equalToSuperview().offset(padding)
            make.height.equalTo(height)
            make.trailing.equalToSuperview().offset(-padding)
        }
        
        desc.snp.makeConstraints{make in
            make.top.equalTo(time.snp.bottom).offset(padding/2)
            make.leading.equalToSuperview().offset(padding)
            make.bottom.trailing.equalToSuperview().offset(-padding)
        }
        
    }
    
    func configure(for sale: Sale) {
        self.sale = sale
        town.text = "\(sale.type.rawValue) Sale - \(sale.address.town)"
        time.text = "\(sale.dateRange.getStartTime())-\(sale.dateRange.getEndTime())"
        date.text = "\(sale.dateRange.getShortWeekday())."
        desc.text = sale.desc
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

