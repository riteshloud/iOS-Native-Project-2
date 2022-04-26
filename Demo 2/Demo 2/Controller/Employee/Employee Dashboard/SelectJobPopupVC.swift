//
//  SelectJobPopupVC.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 22/05/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

protocol selectedJobFromList {
    func getSelectedJobFromList(_ arrSelectedJob: [JobListObject])
}

class SelectJobPopupVC: UIViewController {

    // MARK:- PROPERTIES & OUTLETS -
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnPunchIn: UIButton!
    
    var delegate: selectedJobFromList?
    var arrJobs: [JobListObject] = []
    var arrSelectedJob: [JobListObject] = []
    var arrSelectedJobIDs: [Int] = []
    
    // MARK:- VIEWCONTROLLER LIFE CYCLE -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         
    }
    
    // MARK:- ACTIONS -
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCloseClick(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPunchInTapped(_ sender: UIButton) {
        self.delegate?.getSelectedJobFromList(self.arrSelectedJob)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK:- UITABLEVIEW DATASOURCE & DELEGATE -

extension SelectJobPopupVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrJobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as! CategoryCell
        
        let objJob = self.arrJobs[indexPath.row]
        cell.lblName.text = objJob.job_title
        
        if self.arrSelectedJobIDs.contains(objJob.id) {
            cell.btnCheck.setImage(UIImage(named: "ic_radioselected"), for: .normal)
        } else {
            cell.btnCheck.setImage(UIImage(named: "ic_radiodeselected"), for: .normal)
        }
    
        cell.btnCheck.tag = indexPath.row
        cell.btnCheck.addTarget(self, action: #selector(btnCheckTapped), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let objJob = self.arrJobs[indexPath.row]
        
        if self.arrSelectedJobIDs.contains(objJob.id) {
            self.arrSelectedJobIDs.removeAll()
            self.arrSelectedJob.removeAll()
        } else {
            self.arrSelectedJobIDs.removeAll()
            self.arrSelectedJob.removeAll()
            self.arrSelectedJobIDs.append(objJob.id)
            self.arrSelectedJob.append(objJob)
        }
        
        self.tblView.reloadData()
    }
    
    @objc func btnCheckTapped(_ sender : UIButton) {
        let objJob = self.arrJobs[sender.tag]
        
        if self.arrSelectedJobIDs.contains(objJob.id) {
            self.arrSelectedJobIDs.removeAll()
            self.arrSelectedJob.removeAll()
        } else {
            self.arrSelectedJobIDs.removeAll()
            self.arrSelectedJob.removeAll()
            self.arrSelectedJobIDs.append(objJob.id)
            self.arrSelectedJob.append(objJob)
        }
        
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
}
