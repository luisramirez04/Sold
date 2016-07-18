//
//  Cell.swift
//  Sold
//
//  Created by Luis Ramirez on 7/14/16.
//  Copyright © 2016 Luis Ramirez. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    
    @IBOutlet weak var userThatCommented: UILabel!
    @IBOutlet weak var imageCommented: UIImageView!
  
    @IBOutlet weak var messageThatMatched: UILabel!
    
    @IBOutlet weak var dateForComment: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
