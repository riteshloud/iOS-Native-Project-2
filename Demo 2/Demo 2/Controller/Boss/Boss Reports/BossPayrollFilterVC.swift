//
//  BossPayrollFilterVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 10/06/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

protocol bossReportFilterDelegate {
    func getSelectedReportFilter(_ startDate: String, _ endDate: String, _ arrSelectedEmployee: [EmployeeListObject])
}

class BossPayrollFilterVC: BaseVC {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var txtFromDate: NoPopUpTextField!
    @IBOutlet weak var txtToDate: NoPopUpTextField!
    
    @IBOutlet weak var txtEmployee: UITextField!

    @IBOutlet weak var clViewEmployee: UICollectionView!
    @IBOutlet weak var clViewEmployeeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnApply: UIButton!
    
    var dateFormatter = DateFormatter()
    
    var arrEmployeeList: [EmployeeListObject] = []
    var arrSelectedEmployee: [EmployeeListObject] = []
    
    let reuseIdentifier = "BossExpenseFilterCell"
    
    var delegate: bossReportFilterDelegate?
    
    var strStartDate: String = ""
    var strEndDate: String = ""
    var arrFilteredData:[String] = []
    var isUserUpdateFilter: Bool = false
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    // MARK:- HELPER -
    func checkFilterUpdationAndChangeButtonTitle() {
        if self.isUserUpdateFilter {
            self.btnApply.setTitle("Apply".localized(), for: [])
        }
        else {
            self.btnApply.setTitle("Clear".localized(), for: [])
        }
    }
    
    // MARK:- ACTIONS -
    
    @objc func doneButtonClicked(_ sender: UITextField) {
        if sender == self.txtFromDate {
            if let picker = sender.inputView as? UIDatePicker {
                self.txtFromDate.text = picker.date.getDateOnly()
            }
        }
        else if sender == self.txtToDate {
            if let picker = sender.inputView as? UIDatePicker {
                self.txtToDate.text = picker.date.getDateOnly()
            }
        }
    }
    
    @objc func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnDateSelectionTapped(_ sender: UIButton) {
        if sender.accessibilityIdentifier == "FROM_DATE" {
            self.txtFromDate.becomeFirstResponder()
        } else if sender.accessibilityIdentifier == "TO_DATE" {
            self.txtToDate.becomeFirstResponder()
        }
    }
    
    @IBAction func btnApplyFilterTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Apply".localized() {
            if self.txtFromDate.isEmpty() == 0 {
                if self.txtToDate.isEmpty() == 1 {
                    AppFunctions.displayAlert("To date is required".localized())
                } else {
                    self.delegate?.getSelectedReportFilter(self.txtFromDate.text ?? "", self.txtToDate.text ?? "", self.arrSelectedEmployee)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            else {
                self.delegate?.getSelectedReportFilter(self.txtFromDate.text ?? "", self.txtToDate.text ?? "", self.arrSelectedEmployee)
                self.navigationController?.popViewController(animated: true)
            }
        }
        else if sender.titleLabel?.text == "Clear".localized() {
            self.delegate?.getSelectedReportFilter("", "", [])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func updateFromDateField(sender: UIDatePicker) {
        self.txtFromDate.text = sender.date.getDateOnly()
    }
    
    @objc func updateToDateField(sender: UIDatePicker) {
        self.txtToDate.text = sender.date.getDateOnly()
    }
    
    @IBAction func btnEmployeeClick(_ sender: UIButton) {
        self.view.endEditing(true)
    }
}


// MARK:- UITEXTFIELD DELEGATE METHOD -

extension BossPayrollFilterVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.isUserUpdateFilter = true
        self.checkFilterUpdationAndChangeButtonTitle()
        
        if textField == self.txtFromDate {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
            if self.txtToDate.text != "" {
                datePicker.maximumDate = self.dateFormatter.date(from: self.txtToDate.text ?? "")
            } else {
                datePicker.maximumDate = Date()
            }
            datePicker.date = Date.getSelectedDateFromString(self.txtFromDate.text ?? Date.getDateOnly())
            datePicker.addTarget(self, action: #selector(updateFromDateField(sender:)), for: .valueChanged)
            
            if #available(iOS 14, *) {
                datePicker.preferredDatePickerStyle = .wheels
            }
            self.txtFromDate.inputView = datePicker
        } else if textField == self.txtToDate {
            if self.txtFromDate.text == "" {
                AppFunctions.displayAlert("From date is required".localized())
                return false
            } else {
                let datePicker = UIDatePicker()
                datePicker.datePickerMode = .date
                datePicker.timeZone = NSTimeZone(name: globalTimezone) as TimeZone?
                
                let fromDate = AppFunctions.sharedInstance.convertStringToDate(StrDate: self.txtFromDate.text ?? "", DateFormat: globalDateFormat)
                datePicker.minimumDate = fromDate
                datePicker.maximumDate = Date()
                datePicker.date = Date.getSelectedDateFromString(self.txtToDate.text ?? Date.getDateOnly())
                datePicker.addTarget(self, action: #selector(updateToDateField(sender:)), for: .valueChanged)
                
                if #available(iOS 14, *) {
                    datePicker.preferredDatePickerStyle = .wheels
                }
                self.txtToDate.inputView = datePicker
            }
        }
        return true
    }
}

// MARK:- UICOLLECTIONVIEW DATASOURCE & DELEGATE METHOD -

extension BossPayrollFilterVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSelectedEmployee.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! BossExpenseFilterCell
        
        let objEmployee = self.arrSelectedEmployee[indexPath.item]
        cell.lblName.text = objEmployee.name
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("You selected cell #\(indexPath.item)!")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 45)
    }
}
