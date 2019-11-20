//
//  ProfileViewController.swift
//  Final Challenge
//
//  Created by Muhammad Reynaldi on 09/11/19.
//  Copyright © 2019 12. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var dataArray:[Any?] = []
    let header = "TitleTableViewCellID"
    let content = "ContentTableViewCellID"
    let anotherContent = "AnotherContentTableViewCellID"
    let achievement = "AchievementTableViewCellID"
    let contentView = "ContentViewTableViewCellID"
    let logoutView = "LogoutTableViewCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        cellDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupView(text: "Profil")
        setupData()
        tableView.reloadData()
    }
    
}
extension ProfileViewController{
    private func setupData() {
        dataArray.removeAll()
        dataArray.append(tutor)
        dataArray.append(("Keterampilan","Tambah Keterampilan",0))
        dataArray.append(("Bahasa","Tambah Bahasa"))
        dataArray.append(("Pendidikan","Edit Pendidikan",1))
        dataArray.append(("Pengalaman","Tambah Pengalaman"))
        dataArray.append(("Pencapaian","Tambah Pencapain",2))
        dataArray.append(false)
    }
    
    private func addAchievement() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Batal", style: .cancel, handler: nil)
        let file = UIAlertAction(title: "Pilih Dari File", style: .default) { action in
            
            //Select from file
        }
        
        actionSheet.addAction(file)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}
extension ProfileViewController:ProfileProtocol{
    func pencilTapped() {
        let destVC = EditProfileViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func skillTapped() {
        let destVC = SkillsViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func languageTapped() {
        let destVC = LanguageViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func educationTapped() {
        let destVC = EducationViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func experienceTapped() {
        let destVC = ExperienceViewController()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func achievementTapped() {
        addAchievement()
    }
    
    func logout() {
        //Back to Login as Bimbel or Pengajar
    }
    
}
extension ProfileViewController:UITableViewDataSource, UITableViewDelegate{
    private func registerCell() {
        tableView.register(UINib(nibName: "TitleTableViewCell", bundle: nil), forCellReuseIdentifier: header)
        tableView.register(UINib(nibName: "ContentTableViewCell", bundle: nil), forCellReuseIdentifier: content)
        tableView.register(UINib(nibName: "AnotherContentTableViewCell", bundle: nil), forCellReuseIdentifier: anotherContent)
        tableView.register(UINib(nibName: "AchievementTableViewCell", bundle: nil), forCellReuseIdentifier: achievement)
        tableView.register(UINib(nibName: "ContentViewTableViewCell", bundle: nil), forCellReuseIdentifier: contentView)
        tableView.register(UINib(nibName: "LogoutTableViewCell", bundle: nil), forCellReuseIdentifier: logoutView)
    }
    
    private func cellDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: header, for: indexPath) as! TitleTableViewCell
            if let tutor = dataArray[indexPath.row] as? Tutor {
                let fullName = tutor.tutorFirstName + " " + tutor.tutorLastName
                cell.setCell(image: tutor.tutorImage, name: fullName, university: "Bina Nusantara", age: 22)
                print(fullName)
            }
            cell.contentDelegate = self
            return cell
        }else if let keyValue = dataArray[indexPath.row] as? (key:String, value:String, code:Int){
            if keyValue.code == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: content, for: indexPath) as! ContentTableViewCell
                cell.setCell(title: keyValue.key, button: keyValue.value)
                cell.contentDelegate =  self
                return cell
            }else if keyValue.code == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: contentView, for: indexPath) as! ContentViewTableViewCell
                cell.setCell(text: keyValue.key, button: keyValue.value)
                cell.contentDelegate = self
                return cell
            }else if keyValue.code == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: achievement, for: indexPath) as! AchievementTableViewCell
                cell.setCell(label: keyValue.key, button: keyValue.value)
                cell.contentDelegate = self
                return cell
            }
        }else if let keyValue = dataArray[indexPath.row] as? (key:String, value:String){
            let cell = tableView.dequeueReusableCell(withIdentifier: anotherContent, for: indexPath) as! AnotherContentTableViewCell
            cell.setCell(text: keyValue.key, button: keyValue.value)
            cell.customIndex = indexPath.row
            cell.contentDelegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: logoutView, for: indexPath) as! LogoutTableViewCell
            cell.contentDelegate = self
            cell.setInterface()
            return cell
        }
        return UITableViewCell()
    }
    
}
