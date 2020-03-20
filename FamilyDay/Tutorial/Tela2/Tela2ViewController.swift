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
    
    func irParaHome(){
        
        let navigation = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SegundoNavigationController") as! UINavigationController
        let tab = navigation.viewControllers.first as! UITabBarController
        let vcHome = tab.viewControllers?.first as! HomeViewController
        
        UsuarioDao.getUserfor(token: Configuration.shared.token!) { (usuario) in
            if let user = usuario {
                vcHome.user = user

                self.present(navigation, animated: true, completion: nil)
                self.navigationController?.popViewController(animated: false)
                self.navigationController?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func gravarFamilia(_ sender: Any) {
        indicator.isHidden = false
        
        FamiliaDao.cadastrarFamilia(nomeFamilia: nomeGrupo, idUsuario: idUsuario) { (sucesso) in
            if sucesso {
                self.indicator.isHidden = true
                self.navigationController?.pushViewController(CadastroMetaViewController(), animated: true)
            }
        }
    }
}
