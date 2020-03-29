//
//  Tela2ViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 27/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class Tela2ViewController: UIViewController {

    @IBOutlet weak var labelDescricao: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var nomeGrupo: String!
    var idUsuario: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let grupo = nomeGrupo {
            labelDescricao.text = "Nome do grupo \(grupo) passado por parâmetro"
        }
        indicator.isHidden = true
    }
    
    @IBAction func gravarFamilia(_ sender: Any) {
        indicator.isHidden = false
        
        FamiliaDao.cadastrarFamilia(nomeFamilia: nomeGrupo, idUsuario: idUsuario) { (sucesso) in
            if sucesso {
                self.indicator.isHidden = true
                let vc = CadastroMetaViewController()
                vc.metaInicial = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
