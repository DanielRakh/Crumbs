//
//  CBCrumbCell.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import UIKit

class CBCrumbCell: UITableViewCell {

    @IBOutlet weak var crumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    var viewModel:CBCrumbsTableViewCellModeling?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
