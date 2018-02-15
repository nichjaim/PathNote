//
//  NearbyPostsTableViewCell.swift
//  Helpem
//
//  Created by Nicholas Jaimes on 1/1/18.
//  Copyright © 2018 Nicholas Jaimes. All rights reserved.
//

import UIKit

class NearbyPostsTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var lblCellPostMessage: UILabel!
    
    
    @IBOutlet weak var btnCellPostReport: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
