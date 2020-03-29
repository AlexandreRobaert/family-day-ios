//
//  DetalhesUsuarioViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 27/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class DetalhesUsuarioViewController: UIViewController {

    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var dataNascimentoLabel: UILabel!
    @IBOutlet weak var tipoPerfilLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var viewSeparator: UIView!
    @IBOutlet weak var textoDescricaoQRCodeLabel: UILabel!
    @IBOutlet weak var imageQRCode: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    var usuario: Usuario!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatData = DateFormatter()
        formatData.dateFormat = "dd/MM/yyyy"
        
        nomeLabel.text = usuario.nome
        dataNascimentoLabel.text = formatData.string(from: usuario.dataNascimento!)
        tipoPerfilLabel.text = usuario.tipo
        
        if usuario.ativo {
            statusLabel.textColor = .green
            statusLabel.text = "Ativo"
            imageQRCode.isHidden = true
            textoDescricaoQRCodeLabel.isHidden = true
            viewSeparator.isHidden = true
        }else{
            indicator.isHidden = false
            UsuarioDao.getTokenMembroFor(id: usuario.id!) { (token) in
                if let token = token {
                    let image = Utils.generateQRCode(from: token)
                    self.indicator.isHidden = true
                    self.imageQRCode.image = image
                }
            }
            statusLabel.textColor = .red
            statusLabel.text = "Inavito"
        }
        
    }
}
