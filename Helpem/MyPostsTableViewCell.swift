//
//  MyPostsTableViewCell.swift
//  Helpem
//
//  Created by Nicholas Jaimes on 12/21/17.
//  Copyright © 2017 Nicholas Jaimes. All rights reserved.
//

import UIKit

class MyPostsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var lblCellPostMessage: UILabel!
    
    
    @IBOutlet weak var btnCellPostDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
