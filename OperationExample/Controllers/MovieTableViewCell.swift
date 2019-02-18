//
//  MovieTableViewCell.swift
//  OperationExample
//
//  Created by Kyaw Kyaw Lay on 4/2/19.
//  Copyright © 2019 Kyaw Kyaw Lay. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var cell_image: UIImageView!
    @IBOutlet weak var cell_label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
