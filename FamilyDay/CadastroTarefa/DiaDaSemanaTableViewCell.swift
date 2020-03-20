//
//  DiaDaSemanaTableViewCell.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 19/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class DiaDaSemanaTableViewCell: UITableViewCell {

    @IBOutlet weak var uiSwitch: UISwitch!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func mudouTodoDia(_ sender: UISwitch) {
        
    }
}
