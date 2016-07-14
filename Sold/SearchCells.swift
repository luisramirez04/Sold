//
//  SearchCells.swift
//  Sold
//
//  Created by Luis Ramirez on 7/9/16.
//  Copyright © 2016 Luis Ramirez. All rights reserved.
//

import UIKit

class SearchCells: UITableViewCell {


    
    @IBOutlet weak var imageForComment: UIImageView!
    @IBOutlet weak var user: UILabel!
    @IBOutlet weak var commentMessage: UILabel!

    @IBOutlet weak var commentTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
