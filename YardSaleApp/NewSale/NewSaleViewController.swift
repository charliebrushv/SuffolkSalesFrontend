//
//  NewSaleViewController.swift
//  YardSaleApp
//
//  Created by Charlie Brush on 6/7/21.
//

import UIKit
import MapKit

class NewSaleViewController: UIViewController {
    
    var newSaleLabel: UILabel!
    
    var streetLabel: UILabel!
    var townLabel: UILabel!
    var zipLabel: UILabel!
    var streetField: UITextField!
    var townField: UITextField!
    var zipField: UITextField!
    
//    var startDateLabel: UILabel!
//    var endDateLabel: UILabel!
//    var startDatePicker: UIDatePicker!
//    var endDatePicker: UIDatePicker!
    
    var dateLabel: UILabel!
    var datePicker: UIDatePicker!
    var startTimeLabel: UILabel!
    var startTimePicker: UIDatePicker!
    var endTimeLabel: UILabel!
    var endTimePicker: UIDatePicker!
    
    var typeLabel: UILabel!
    var typeCollectionView: UICollectionView!
    let reuseIdentifier = "typeCellReuse"
    
    var descLabel: UILabel!
    var descField: UITextView!
    var doneButton: UIButton!
    
    var postButton: UIButton!
    
    var trashButton: UIButton!
    
    weak var delegate: navigationControllerDelegate?
    var mapTableDelegate: MapTableDelegate?
    
    var types: [Type]!
    
    var chosenType: Type?
    
    let alert = UIAlertController(title: "Delete Sale", message: "This cannot be undone", preferredStyle: .alert)
        
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        types = [Type(type: .tag), Type(type: .yard), Type(type: .garage), Type(type: .estate)]
        
        setUpViews()
        setUpConstraints()
        
        if let saleId = userDefaults.value(forKey: "mySale") as? Int {
            NetworkManager.getSale(sale: saleId) {sale in
                self.newSaleLabel.text = "Edit Your Sale"
                self.streetField.text = sale.address.street
                self.townField.text = sale.address.town
                self.zipField.text = sale.address.zip
                //is this enough to set the selected tag?
                let t = ["Tag":0,"Yard":1,"Garage":2,"Estate":3]
//                self.types[t[sale.type.rawValue]!].isOn = true
//                self.typeCollectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: false, scrollPosition: [])
                self.typeCollectionView.selectItem(at: [0,t[sale.type.rawValue]!], animated: false, scrollPosition: [])
//                self.typeCollectionView.selectItem(at: IndexPath(index: 0), animated: false, scrollPosition: [])
                self.typeCollectionView.delegate?.collectionView?(self.typeCollectionView, didSelectItemAt: [0,t[sale.type.rawValue]!])
                self.datePicker.date = sale.dateRange.date
                self.startTimePicker.date = sale.dateRange.startTime
                self.endTimePicker.date = sale.dateRange.endTime
                self.descField.text = sale.desc
                self.descField.textColor = .black
                self.trashButton.isHidden = false
            }
        }
    }
    
    func setUpViews() {
        newSaleLabel = UILabel()
        newSaleLabel.translatesAutoresizingMaskIntoConstraints = false
        newSaleLabel.font = .systemFont(ofSize: 30, weight: .bold)
        newSaleLabel.numberOfLines = 1
        newSaleLabel.textColor = .black
        newSaleLabel.backgroundColor = .white
        newSaleLabel.textAlignment = .center
        newSaleLabel.text = "New Sale"
        view.addSubview(newSaleLabel)
        
        streetLabel = newLabel(text: "Street:")
        view.addSubview(streetLabel)
        townLabel = newLabel(text: "City/Town:")
        view.addSubview(townLabel)
        zipLabel = newLabel(text: "Zip:")
        view.addSubview(zipLabel)
        
        streetField = newField(text: "e.g. 20 Hilo Drive")
        streetField.delegate = self
        view.addSubview(streetField)
        townField = newField(text: "e.g. Shelter Island")
        townField.delegate = self
        view.addSubview(townField)
        zipField = newField(text: "e.g. 11964")
        zipField.delegate = self
        view.addSubview(zipField)
        
        let padding: CGFloat = 10
        
        typeLabel = newLabel(text: "Type:")
        view.addSubview(typeLabel)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = padding
        typeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        typeCollectionView.register(TypeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
        typeCollectionView.backgroundColor = .white
        typeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(typeCollectionView)
        
        dateLabel = newLabel(text: "Date:")
        datePicker = UIDatePicker()
        datePicker.backgroundColor = .white
        datePicker.tintColor = .appColor
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = .date
        
        startTimeLabel = newLabel(text: "Start Time:")
        startTimePicker = UIDatePicker()
        startTimePicker.minuteInterval = 5
        startTimePicker.backgroundColor = .white
        startTimePicker.tintColor = .appColor
        startTimePicker.datePickerMode = .time
        startTimePicker.preferredDatePickerStyle = .inline
        startTimePicker.addTarget(self, action: #selector(timeChange), for: .valueChanged)
        
        endTimeLabel = newLabel(text: "End Time:")
        endTimePicker = UIDatePicker()
        endTimePicker.minuteInterval = 5
        endTimePicker.backgroundColor = .white
        endTimePicker.tintColor = .appColor
        endTimePicker.datePickerMode = .time
        endTimePicker.preferredDatePickerStyle = .inline
        
        view.addSubview(dateLabel)
        view.addSubview(datePicker)
        view.addSubview(startTimeLabel)
        view.addSubview(startTimePicker)
        view.addSubview(endTimeLabel)
        view.addSubview(endTimePicker)
        
        descLabel = UILabel()
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = .systemFont(ofSize: 20, weight: .regular)
        descLabel.numberOfLines = 1
        descLabel.textColor = .black
        descLabel.backgroundColor = .white
        descLabel.textAlignment = .left
        descLabel.text = "Description:"
        view.addSubview(descLabel)
        
        descField = UITextView()
        descField.text = "Add a description here."
        descField.clearsOnInsertion = true
        descField.textColor = .lightGray
//        descField.isScrollEnabled = false
        descField.delegate = self
        descField.font = UIFont.systemFont(ofSize: 18)
        descField.isEditable = true
        descField.resignFirstResponder()
       // descField.layer.cornerRadius = 10
        descField.backgroundColor = .white
        view.addSubview(descField)
        
        doneButton = UIButton()
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        doneButton.setTitleColor(.appColor, for: .normal)
        doneButton.setTitleColor(.lightAppColor, for: .highlighted)
        doneButton.contentHorizontalAlignment = .right
        doneButton.isHidden = true
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        view.addSubview(doneButton)
        
        postButton = UIButton()
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.setTitle("Post Sale", for: .normal)
        postButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        postButton.tintColor = .white
        postButton.backgroundColor = .appColor
        postButton.layer.cornerRadius = 30
        postButton.addTarget(self, action: #selector(postTapped), for: .touchUpInside)
        view.addSubview(postButton)
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold, scale: .large)
        
        trashButton = UIButton()
        trashButton.isHidden = true
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        trashButton.setImage(UIImage(systemName: "trash", withConfiguration: config), for: .normal)
        trashButton.tintColor = .red
        trashButton.backgroundColor = .white
        trashButton.addTarget(self, action: #selector(trashTapped), for: .touchUpInside)
        view.addSubview(trashButton)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {_ in
            if let saleId = userDefaults.value(forKey: "mySale") as? Int {
                NetworkManager.deleteSale(sale: saleId) {
                    self.delegate?.getSales()
                    self.mapTableDelegate?.editOrNot(edit: false)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }))
        
    }
    
    @objc func timeChange() {
        if endTimePicker.date<=startTimePicker.date {
            endTimePicker.setDate(startTimePicker.date.advanced(by: 900), animated: true)
        }
    }
    

    func setUpConstraints() {
        let padding: CGFloat = 30
        
//        newSaleLabel.snp.makeConstraints{ make in
//            make.leading.top.equalToSuperview().offset(padding)
//            make.trailing.equalToSuperview().offset(-padding)
//            make.height.equalTo(50)
//        }
        
        newSaleLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.top.equalToSuperview().offset(padding)
            make.height.equalTo(50)
        }
        
        trashButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(padding)
            make.top.equalToSuperview().offset(padding)
            make.height.width.equalTo(50)
        }
        
        constrainLabelTo(label: streetLabel, top: newSaleLabel)
        constrainLabelTo(label: townLabel, top: streetLabel)
        constrainLabelTo(label: zipLabel, top: townLabel)
        constrainFieldTo(field: streetField, top: newSaleLabel, label: streetLabel)
        constrainFieldTo(field: townField, top: streetLabel, label: townLabel)
        constrainFieldTo(field: zipField, top: townLabel, label: zipLabel)
        
        typeLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(zipLabel.snp.bottom).offset(40)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        typeCollectionView.snp.makeConstraints{ make in
            make.leading.equalTo(typeLabel.snp.trailing).offset(20)
            make.top.equalTo(zipLabel.snp.bottom).offset(40)
            make.trailing.equalToSuperview()
            make.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(typeLabel.snp.bottom).offset(40)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        datePicker.snp.makeConstraints{ make in
            make.leading.equalTo(dateLabel.snp.trailing).offset(20)
            make.top.equalTo(dateLabel.snp.top)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalTo(35)
        }
        
        startTimeLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(datePicker.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        endTimeLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(startTimeLabel.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        startTimePicker.snp.makeConstraints{ make in
            make.leading.equalTo(startTimeLabel.snp.trailing).offset(20)
            make.centerY.equalTo(startTimeLabel.snp.centerY)
            make.height.equalTo(60)
            make.width.equalTo(200)
        }
        
        endTimePicker.snp.makeConstraints{ make in
            make.leading.equalTo(endTimeLabel.snp.trailing).offset(20)
            make.centerY.equalTo(endTimeLabel.snp.centerY)
            make.height.equalTo(60)
            make.width.equalTo(200)
        }
        
        descLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(endTimeLabel.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        doneButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(endTimeLabel.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }

        descField.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(descLabel.snp.bottom).offset(15)
            make.bottom.equalTo(postButton.snp.top).offset(-20)
        }
     
        postButton.snp.makeConstraints{ make in
            make.height.equalTo(60)
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    func constrainLabelTo(label: UILabel, top: UIView, offset: CGFloat = 20) {
        let padding: CGFloat = 20
       // let offset: CGFloat = 20
        
        label.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(padding)
            make.top.equalTo(top.snp.bottom).offset(offset)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
    
    func constrainFieldTo(field: UITextField, top: UIView, label: UILabel) {
        let padding: CGFloat = 20
        let offset: CGFloat = 20
        
        field.snp.makeConstraints{ make in
            make.leading.equalTo(label.snp.trailing).offset(padding)
            make.top.equalTo(top.snp.bottom).offset(offset)
            make.width.equalTo(300)
            make.height.equalTo(30)
        }
    }
    
    func newLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .right
        label.text = text
        return label
    }
    
    func newField(text: String) -> UITextField {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        //field.backgroundColor = .lightGray
        field.textColor = .black
        field.placeholder = text
        return field
    }
    
    @objc func postTapped() {
        let empty = streetLabel.text==nil || townLabel.text==nil || zipLabel.text==nil || chosenType==nil || descField.textColor == .lightGray
        let startTime = startTimePicker.date
        let endTime = endTimePicker.date
        print(endTimePicker.date)
        if endTime<=startTime {
            let alert = UIAlertController(title: "Error", message: "End date must come after start date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if empty {
            let alert = UIAlertController(title: "Error", message: "All fields must be filled", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString("\(streetField.text!), \(townField.text!) \(zipField.text!)") {placemarks,error in
                if let placemarks = placemarks {
                    let range = DateRange(date: self.datePicker.date, startTime: startTime, endTime: endTime)
                    var newSale = Sale(desc: self.descField.text, dateRange: range, type: self.chosenType!.type, address: Address(street: self.streetField.text!, town: self.townField.text!, zip: self.zipField.text!))
                    newSale.setCoord(place: placemarks[0])
                    
                    
                    if let saleId = userDefaults.value(forKey: "mySale") as? Int {
                        newSale.id = saleId
                        NetworkManager.postSale(sale: newSale) {
                            self.delegate?.getSales()
                            self.mapTableDelegate?.newSale(sale: newSale)
                        }
                    } else {
                        NetworkManager.createSale(sale: newSale) {id in
                            self.delegate?.getSales()
                            self.mapTableDelegate?.newSale(sale: newSale)
                            userDefaults.setValue(id, forKey: "mySale")
                            print("---")
                            print(userDefaults.integer(forKey: "mySale"))
                        }
                    }
                    
                    
                    
                } else {
                    let alert = UIAlertController(title: "Error", message: "Unable to find location", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            dismiss(animated: true, completion: nil)
        }
       
    }
    
    @objc func doneTapped() {
        descField.endEditing(true)
    }
    
    @objc func trashTapped() {
        self.present(alert, animated: true, completion: nil)
    }
}



extension NewSaleViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextViewDelegate, UITextFieldDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SaleType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = typeCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TypeCollectionViewCell
        cell.configure(for: types[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<types.count {
            if types[i].type != types[indexPath.row].type {
                types[i].isOn = false
            }
        }
        types[indexPath.row].isOn=(!types[indexPath.row].isOn)
        let isOn = types[indexPath.row].isOn
        chosenType = isOn ? types[indexPath.row] : nil
        typeCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: 30)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("editing")
        if textView.textColor==UIColor.lightGray {
            textView.textColor = .black
            textView.text = ""
        }
        doneButton.isHidden = false
        
        
        newConstraints()
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
            self.hidden(is: true)
        }
    }
    
    func hidden(is hidden: Bool) {
        var elements = [newSaleLabel,streetLabel,streetField,townLabel,townField,zipLabel,zipField,typeLabel,typeCollectionView,dateLabel,datePicker,startTimeLabel,startTimePicker,endTimeLabel,endTimePicker]
        if userDefaults.value(forKey: "mySale") != nil {
            elements.append(trashButton)
        }
        for i in elements {
            i?.isHidden = hidden
        }
    }
    
    func newConstraints() {
        self.descLabel.snp.remakeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        self.doneButton.snp.remakeConstraints{ make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
    }

    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("end editing")
        if textView.text=="" {
            textView.textColor = .lightGray
            textView.text = "Add a description here."
        }
        doneButton.isHidden = true
        
        descField.snp.removeConstraints()
        descLabel.snp.removeConstraints()
        doneButton.snp.removeConstraints()
        self.setUpConstraints()
        UIView.animate(withDuration: 0.5) {
            self.hidden(is: false)
            self.view.layoutIfNeeded()
            
        }
    }
    
    func oldConstraints() {
        self.descLabel.snp.remakeConstraints{ make in
            make.leading.equalTo(endTimeLabel.snp.bottom).offset(20)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        self.doneButton.snp.remakeConstraints{ make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(endTimeLabel.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}




