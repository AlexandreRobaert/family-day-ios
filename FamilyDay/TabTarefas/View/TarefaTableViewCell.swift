//
//  TarefaTableViewCell.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 11/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class TarefaTableViewCell: UITableViewCell {

    @IBOutlet weak var tituloTarefa: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
