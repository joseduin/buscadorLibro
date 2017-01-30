//
//  TituloTableViewCell.swift
//  BuscadorLibros
//
//  Created by Jose Duin on 1/30/17.
//  Copyright © 2017 Jose Duin. All rights reserved.
//

import UIKit

class TituloTableViewCell: UITableViewCell {

    @IBOutlet weak var titulo: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
