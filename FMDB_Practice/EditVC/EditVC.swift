//
//  EditVC.swift
//  FMDB_Practice
//
//  Created by 呂淳昇 on 2022/9/14.
//

import UIKit

class EditVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    var id = ResumeSingleton.shared.id
    var name = ResumeSingleton.shared.name
    var age = ResumeSingleton.shared.age
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextField()
        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        ResumeSingleton.shared.id = ""
        ResumeSingleton.shared.name = ""
        ResumeSingleton.shared.age = 0
    }
    
    func setTextField(){
        nameTextField.text = ResumeSingleton.shared.name
        ageTextField.text = String(ResumeSingleton.shared.age)
    }
    
    @IBAction func updateData(_ sender: Any) {
        Database.shared.updateData(id: id, name: nameTextField.text!, age: Int(ageTextField.text!) ?? 10)
        let alert = UIAlertController(title: "", message: "修改資料成功", preferredStyle: .alert)
        let okaction = UIAlertAction(title: "確認", style: .default) { action in
            self.navigationController?.popViewController(animated: false)
        }
        alert.addAction(okaction)
        self.present(alert, animated: false, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
