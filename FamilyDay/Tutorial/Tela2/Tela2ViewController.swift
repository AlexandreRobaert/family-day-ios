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
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let grupo = nomeGrupo {
            labelDescricao.text = "Sua família agora se chamará \(grupo), se for isso mesmo vamos em frente..."
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
                self.navigationController?.viewControllers = [vc]
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}
