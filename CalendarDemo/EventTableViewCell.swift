//
//  EventTableViewCell.swift
//  DewDate
//
//  Created by kang on 2016. 8. 18..
//  Copyright © 2016년 Koreauniv. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    @IBOutlet weak var anothersub_label: UILabel!
    @IBOutlet weak var sub_label: UILabel!
    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var line_color: UIView!
    @IBOutlet weak var line_view: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
