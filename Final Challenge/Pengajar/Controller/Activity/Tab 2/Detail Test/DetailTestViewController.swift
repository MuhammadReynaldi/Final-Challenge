//
//  DetailTestViewController.swift
//  Final Challenge
//
//  Created by Muhammad Reynaldi on 18/11/19.
//  Copyright © 2019 12. All rights reserved.
//

import UIKit
import CloudKit

class DetailTestViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let database = CKContainer.init(identifier: "iCloud.Final-Challenge").publicCloudDatabase
    var dataArray:[Any?] = []
    var jobReference:CKRecord.Reference!
    var applicant:CKRecord?
    var course:CKRecord?
    var job:CKRecord?
    let header = "profileBimbelCell"
    let address = "addressCell"
    let seeDetail = "SeeDetailTableViewCellID"
    let interviewSchedule = "ActivityTableViewCellID"
    let footer = "FooterActivityTableViewCellID"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryJob()
        registerCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.contentInsetAdjustmentBehavior = .never
        setupView(text: "Detail Pekerjaan")
    }
}
extension DetailTestViewController{
    
    private func queryJob() {
        let pred = NSPredicate(format: "recordID = %@", CKRecord.ID(recordName: jobReference.recordID.recordName))
        let query = CKQuery(recordType: "Job", predicate: pred)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let record = records else {return}
            self.job = record[0]
            DispatchQueue.main.async {
                self.queryCourse()
            }
        }
    }
    
    private func queryCourse() {
        let courseID = job?.value(forKey: "courseID") as! CKRecord.Reference
        let pred = NSPredicate(format: "recordID = %@", CKRecord.ID(recordName: courseID.recordID.recordName))
        let query = CKQuery(recordType: "Course", predicate: pred)
        
        database.perform(query, inZoneWith: nil) { (records, error) in
            guard let record = records else {return}
            self.course = record[0]
            DispatchQueue.main.async {
                self.setupData()
                self.cellDelegate()
            }
        }
    }
    
    private func setupData() {
        dataArray.removeAll()
        dataArray.append(course)
        dataArray.append(true)
        let address = (course?.value(forKey: "courseAddress") as! String)
        dataArray.append(("Address",address,0))
        let testReq = (applicant?.value(forKey: "testRequirement") as! String)
        dataArray.append(("Choose Test Schedule","Please select one of the tet schedule","Test Requirement",testReq,"Request New Schedule"))
        dataArray.append(false)
    }
    
}
extension DetailTestViewController:JobDetail{
    func seeDetailTapped() {
        let destVC = SeeDetailBimbelViewController()
        destVC.jobReference = self.jobReference
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
extension DetailTestViewController: UITableViewDataSource,UITableViewDelegate{
    private func cellDelegate(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func registerCell() {
        tableView.register(UINib(nibName: "ProfileBimbelTableViewCell", bundle: nil), forCellReuseIdentifier: header)
        tableView.register(UINib(nibName: "SeeDetailTableViewCell", bundle: nil), forCellReuseIdentifier: seeDetail)
        tableView.register(UINib(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: address)
        tableView.register(UINib(nibName: "ActivityTableViewCell", bundle: nil), forCellReuseIdentifier: interviewSchedule)
        tableView.register(UINib(nibName: "FooterActivityTableViewCell", bundle: nil), forCellReuseIdentifier: footer)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileBimbelCell", for: indexPath) as! ProfileBimbelTableViewCell
            let name = (course?.value(forKey: "courseName") as! String)
            let workHour = ((course?.value(forKey: "courseStartHour") as! String) + " - " + (course?.value(forKey: "courseEndHour") as! String))
            let status = ("Status: " + (applicant?.value(forKey: "status") as! String))
            cell.setView(image: "school", name: name, jam: workHour, status: status)
            return cell
        }else if let keyValue = dataArray[indexPath.row] as? (key:String, value:String, code:Int){
                let cell = tableView.dequeueReusableCell(withIdentifier: "addressCell", for: indexPath) as! AddressTableViewCell
                cell.setView(title: keyValue.key, description: keyValue.value)
                return cell
        }else if let keyValue = dataArray[indexPath.row] as? (key:String, hint:String, anotherKey:String, content:String, button:String){
            let cell = tableView.dequeueReusableCell(withIdentifier: interviewSchedule, for: indexPath) as! ActivityTableViewCell
            cell.day = applicant?.value(forKey: "testDay") as! [String]
            cell.scheduleStart = applicant?.value(forKey: "testStartHour") as! [String]
            cell.scheduleEnd = applicant?.value(forKey: "testEndHour") as! [String]
            cell.setCell(text: keyValue.key, hint: keyValue.hint, anotherText: keyValue.anotherKey, equipment: keyValue.content, button: keyValue.button)
            return cell
        }else if let keyValue = dataArray[indexPath.row] as? Bool{
            if keyValue == true{
                let cell = tableView.dequeueReusableCell(withIdentifier: seeDetail, for: indexPath) as! SeeDetailTableViewCell
                cell.setCell(titleButton: "Request New Schedule")
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: footer, for: indexPath) as! FooterActivityTableViewCell
                cell.setCell(accept: "Accept", reject: "Declined")
                return cell
            }
        }
        return UITableViewCell()
    }
}
