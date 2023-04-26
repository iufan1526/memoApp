//
//  MemoCell.swift
//  memo
//
//  Created by 김승태 on 2023/04/23.
//

import UIKit

class MemoCell: UITableViewCell {

    @IBOutlet weak var titleText: UILabel!   
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var contentText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
