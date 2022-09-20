//
//  ResumeTableViewCell.swift
//  FMDB_Practice
//
//  Created by 呂淳昇 on 2022/9/12.
//

import UIKit

class ResumeTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    var delegate: ResumeTableViewCellListener?
    var index = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setMoreButton()
        setMenu()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setMoreButton(){
        moreButton.setTitle("", for: .normal)
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.showsMenuAsPrimaryAction = true
    }
    
    func setMenu(){
        let detailsAction = UIAction(title: "詳細資料", image: UIImage(systemName: "square.and.pencil"), handler: { action in
            print("詳細資料")
            self.delegate?.buttonClicked(buttonType: "details", index: self.index)
        })
        
        let deleteAction = UIAction(title: "刪除", image: UIImage(systemName: "trash.fill"), attributes: .destructive, handler: { action in
            print("刪除")
            self.delegate?.buttonClicked(buttonType: "delete", index: self.index)
        })
        
        let menu = UIMenu(children: [detailsAction, deleteAction])
        moreButton.menu = menu
    }
}
protocol ResumeTableViewCellListener{
    func buttonClicked(buttonType: String, index: Int)
}
