//
//  MainVC.swift
//  FMDB_Practice
//
//  Created by 呂淳昇 on 2022/9/8.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var resumeTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var resumeList = [Resume]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        searchBar.delegate = self
        Database.shared.createTable()
        setTableView()
        registerCell()
        fetchData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func setTableView(){
        resumeTableView.delegate = self
        resumeTableView.dataSource = self
    }
    
    func registerCell(){
        let nib = UINib(nibName: "ResumeTableViewCell", bundle: nil)
        resumeTableView.register(nib, forCellReuseIdentifier: "ResumeTableViewCell")
    }
    
    func fetchData(){
        resumeList = Database.shared.fetchData()
        DispatchQueue.main.async {
            self.resumeTableView.reloadData()
        }
    }
    
    func search(_ searchTerm: String) {
        if searchTerm.isEmpty == false {
            resumeList = Database.shared.fetchData().filter {
                $0.name.contains(searchTerm.lowercased()) || $0.name.contains(searchTerm.uppercased())
            }
        }
        resumeTableView.reloadData()
    }
    
    @IBAction func addData(_ sender: Any) {
        if nameTextField.text != "" && ageTextField.text != ""{
            Database.shared.insertData(id: UUID().uuidString, name: nameTextField.text!, age: Int(ageTextField.text!) ?? 10)
        }
        nameTextField.text = ""
        ageTextField.text = ""
        fetchData()
    }
    
}
extension MainVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resumeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResumeTableViewCell",for: indexPath) as! ResumeTableViewCell
        cell.nameLabel.text = resumeList[indexPath.row].name
        cell.ageLabel.text = String(resumeList[indexPath.row].age)
        cell.delegate = self
        return cell
    }
    
    
}
extension MainVC: ResumeTableViewCellListener{
    func buttonClicked(buttonType: String, index: Int) {
        switch buttonType {
        case "details" :
            ResumeSingleton.shared.id = resumeList[index].id
            ResumeSingleton.shared.name = resumeList[index].name
            ResumeSingleton.shared.age = resumeList[index].age
            let nextVC = EditVC()
            self.navigationController?.pushViewController(nextVC, animated: false)
        case "delete" :
            Database.shared.deleteData(id: resumeList[index].id)
            self.fetchData()
        default:
            break
        }
        
    }
}
extension MainVC: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        resumeTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(searchText)
        if searchText == "" {
            fetchData()
            resumeTableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        resumeTableView.reloadData()
    }
}
