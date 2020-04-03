//
//  MetaTableViewCell.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 10/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class MetaTableViewCell: UITableViewCell {

    @IBOutlet weak var imageMeta: UIImageView!
    @IBOutlet weak var tituloMetaLabel: UILabel!
    @IBOutlet weak var nomeFilhoLabel: UILabel!
    @IBOutlet weak var pontosLabel: UILabel!
    @IBOutlet weak var progressoMeta: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuraCelula(_ meta: Meta){
        imageMeta.image = UIImage(systemName: "tortoise.fill")
        tituloMetaLabel.text = meta.titulo
        pontosLabel.text = "Pontos \(String(describing: meta.pontosAlvo))"
    }

}
