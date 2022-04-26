//
//  CountryPopupVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

protocol SelectCountryCodeDelegate {
    func selectedCountry(countryCode: String)
}

class CountryPopupVC: BaseVC {

    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblCountries: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    var arrCountries:[CountryCodeObject] = []
    var filterArrCountries:[CountryCodeObject] = []
    
    var searchActive: Bool = false
    
    var delegate: SelectCountryCodeDelegate?
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //ADDED NOTIFICATION OBSERVER TO NOTIFY ON KEYBOARD SHOW/HIDE
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK:- HELPER -
    //TO AVOIDE DATA GOES BEHIND TABLEVIEW WE SET TABLEVIEW BOTTOM OFFSET TO KEYBOARD HEIGHT SO THAT TABLEVIEW LAST RECORD DISPLAY ABOVE KEYBOARD
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.tblCountries.setBottomInset(to: keyboardHeight)
        }
    }

    //RESET TABLEVIEW BOTTOM OFFSET TO 0 ON KEYBOARD HIDES
    @objc func keyboardWillHide(notification: Notification) {
        self.tblCountries.setBottomInset(to: 0.0)
    }
    
    // MARK:- ACTIONS -
    
    @objc func dismissKeyboard() {
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- SEARCH BAR DELEGATE -

extension CountryPopupVC: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            self.searchActive = false
        }
        else {
            self.searchActive = true
            self.filterArrCountries = (self.arrCountries.filter{$0.name.localizedLowercase.localizedCaseInsensitiveContains(searchText)} as NSArray) as! [CountryCodeObject]
        }

        self.tblCountries.reloadData()
    }
}

// MARK:- UITABLEVIEW DATASOURCE & DELEGATE -

extension CountryPopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive == true {
            if self.searchBar.text == "" {
                self.lblNoRecord.isHidden = true
                return self.arrCountries.count
            } else {
                if self.filterArrCountries.count > 0 {
                    self.lblNoRecord.isHidden = true
                } else {
                    self.lblNoRecord.isHidden = false
                }
                return filterArrCountries.count
            }
        } else {
            self.lblNoRecord.isHidden = true
            return self.arrCountries.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountriesCell") as! CountriesCell
    
        if self.searchActive {
            let objCountryCode = self.filterArrCountries[indexPath.row]
            cell.lblCountryName.text = objCountryCode.name
            cell.lblCountryCode.text = objCountryCode.code
        }
        else {
            let objCountryCode = self.arrCountries[indexPath.row]
            cell.lblCountryName.text = objCountryCode.name
            cell.lblCountryCode.text = objCountryCode.code
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.searchActive {
            let objCountryCode = self.filterArrCountries[indexPath.row]
            self.delegate?.selectedCountry(countryCode: objCountryCode.code)
        }
        else {
            if self.searchBar.text?.count ?? "".count <= 0 {
                self.searchActive = false
                let objCountryCode = self.arrCountries[indexPath.row]
                self.delegate?.selectedCountry(countryCode: objCountryCode.code)
            }
            else {
                self.searchActive = true
                let objCountryCode = self.filterArrCountries[indexPath.row]
                self.delegate?.selectedCountry(countryCode: objCountryCode.code)
            }
        }

        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
