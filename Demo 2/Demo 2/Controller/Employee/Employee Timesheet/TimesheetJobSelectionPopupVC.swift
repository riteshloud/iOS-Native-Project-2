//
//  TimesheetJobSelectionPopupVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 15/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

protocol jobSingleSelectionDelegate {
    func getSignleSelectedJob(_ arrSelectedJob: [JobListObject])
}

class TimesheetJobSelectionPopupVC: UIViewController {
    
    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblNoRecord: UILabel!
    
    var delegate: jobSingleSelectionDelegate?
    
    var searchActive: Bool = false
    var arrSearchedJob: [JobListObject] = []
    var arrJobs: [JobListObject] = []
    var arrSelectedJob: [JobListObject] = []
    var arrSelectedJobIDs: [Int] = []
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //ADDED NOTIFICATION OBSERVER TO NOTIFY US ON KEYBOARD SHOW/HIDE
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
            self.tblView.setBottomInset(to: keyboardHeight)
        }
    }

    //RESET TABLEVIEW BOTTOM OFFSET TO 0 ON KEYBOARD HIDES
    @objc func keyboardWillHide(notification: Notification) {
        self.tblView.setBottomInset(to: 0.0)
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

extension TimesheetJobSelectionPopupVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        self.searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.arrSearchedJob = (self.arrJobs.filter{$0.job_title.localizedLowercase.localizedCaseInsensitiveContains(searchText)} as NSArray) as! [JobListObject]
        
        if self.searchBar.text == "" && self.arrSearchedJob.count == 0 {
            self.lblNoRecord.isHidden = true
        } else {
            if self.arrSearchedJob.count > 0 {
                self.lblNoRecord.isHidden = true
            } else {
                self.lblNoRecord.isHidden = false
            }
        }
        self.tblView.reloadData()
    }
}

// MARK:- UITABLEVIEW DATASOURCE & DELEGATE -

extension TimesheetJobSelectionPopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive == true {
            if self.searchBar.text == "" {
                return self.arrJobs.count
            } else {
                return self.arrSearchedJob.count
            }
        } else {
            if self.arrJobs.count <= 0 {
                self.lblNoRecord.isHidden = false
            }
            else {
                self.lblNoRecord.isHidden = true
            }
            return self.arrJobs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        var objJob: JobListObject!
        
        if self.searchActive {
            if self.arrSearchedJob.count > 0 {
                objJob = self.arrSearchedJob[indexPath.row]
            } else {
                objJob = self.arrJobs[indexPath.row]
            }
        } else {
            objJob = self.arrJobs[indexPath.row]
        }
        
        cell.lblName.text = objJob.job_title
        
        if self.arrSelectedJobIDs.contains(objJob.id) {
            cell.btnCheck.setImage(UIImage(named: "ic_radioselected"), for: .normal)
        }
        else {
            cell.btnCheck.setImage(UIImage(named: "ic_radiodeselected"), for: .normal)
        }
        
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(btnCheckTapped), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var objJob: JobListObject!
        
        if self.searchActive {
            if self.arrSearchedJob.count > 0 {
                objJob = self.arrSearchedJob[indexPath.row]
            } else {
                objJob = self.arrJobs[indexPath.row]
            }
        } else {
            if self.searchBar.text != "" {
                if self.arrSearchedJob.count > 0 {
                    objJob = self.arrSearchedJob[indexPath.row]
                }
            } else {
                objJob = self.arrJobs[indexPath.row]
            }
        }
        
        self.arrSelectedJob.removeAll()
        self.arrSelectedJobIDs.removeAll()
        
        self.arrSelectedJobIDs.append(objJob.id)
        self.arrSelectedJob.append(objJob)
        
        self.tblView.reloadData()
        self.delegate?.getSignleSelectedJob(self.arrSelectedJob)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func btnCheckTapped(_ sender : UIButton) {
        var objJob: JobListObject!
        
        if self.searchActive {
            if self.arrSearchedJob.count > 0 {
                objJob = self.arrSearchedJob[sender.tag]
            } else {
                objJob = self.arrJobs[sender.tag]
            }
        } else {
            if self.searchBar.text != "" {
                if self.arrSearchedJob.count > 0 {
                    objJob = self.arrSearchedJob[sender.tag]
                }
            } else {
                objJob = self.arrJobs[sender.tag]
            }
        }
        
        self.arrSelectedJob.removeAll()
        self.arrSelectedJobIDs.removeAll()
        
        self.arrSelectedJobIDs.append(objJob.id)
        self.arrSelectedJob.append(objJob)
        
        self.tblView.reloadData()
        self.delegate?.getSignleSelectedJob(self.arrSelectedJob)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
