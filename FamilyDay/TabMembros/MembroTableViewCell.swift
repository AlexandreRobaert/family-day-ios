//
//  MembroTableViewCell.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 19/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class MembroTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagemPerfil: UIImageView!
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var tipoPerfilLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configuraCelula(user: Usuario){
        self.nomeLabel.text = user.nome
        self.tipoPerfilLabel.text = user.tipo!
        
        if user.id! == Configuration.shared.idUsuario! {
            self.nomeLabel.text = user.nome + " - Você"
            self.nomeLabel.textColor = UIColor(named: "Roxo")
        }
    }
}
