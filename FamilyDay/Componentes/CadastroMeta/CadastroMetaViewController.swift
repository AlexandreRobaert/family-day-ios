//
//  CadastroMetaViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 09/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

protocol TabelaMetasDelegate {
    func atualizarTabelaDeMetas(meta: Meta)
}

class CadastroMetaViewController: UIViewController {

    @IBOutlet weak var tituloDaTelaLabel: UILabel!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var descricaoTextField: UITextField!
    @IBOutlet weak var pontosTextField: UITextField!
    @IBOutlet weak var cadastrarButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    var meta: Meta?
    var delegate: TabelaMetasDelegate?
    var metaInicial: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.layer.cornerRadius = 10
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.8
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let meta = meta {
            tituloDaTelaLabel.text = "Altere sua Meta"
            cadastrarButton.setTitle("Alterar", for: .normal)
            cadastrarButton.tag = 222
            tituloTextField.text = meta.titulo
            descricaoTextField.text = meta.descricao
            pontosTextField.text = String(meta.pontosAlvo)
            
            if metaInicial {
                navigationController?.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func irParaHome(){
        let tab:UITabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbarhome") as! UITabBarController
        let navigation = tab.viewControllers?.first as! UINavigationController
        let vcHome = navigation.viewControllers[0] as! HomeViewController
        
        UsuarioDao.getUserfor(token: Configuration.shared.token!) { (usuario) in
            if let user = usuario {
                vcHome.user = user

                self.navigationController?.viewControllers = []
                self.navigationController?.popToRootViewController(animated: false)
                self.navigationController?.dismiss(animated: true, completion: nil)
                self.present(tab, animated: true, completion: nil)
            }
        }
    }

    @IBAction func cadastrarAtualizarMeta(_ sender: Any) {
        
        for textField in Utils.getTextfield(view: view) {
            textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }

        if !Utils.temTextFieldVazia(view: view){
             
            self.meta = Meta(id: meta?.id!, titulo: tituloTextField.text!, descricao: descricaoTextField.text!, pontosAlvo: (pontosTextField.text! as NSString).integerValue)
            
            if cadastrarButton.tag == 111 {
                MetaDao.cadastrarMeta(meta: meta!) { (idMeta) in
                    if let id = idMeta {
                        self.meta?.id = id
                        if !self.metaInicial {
                            self.delegate?.atualizarTabelaDeMetas(meta: self.meta!)
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            self.irParaHome()
                        }
                    }
                }
            } else {
                MetaDao.atualizarMeta(meta: meta!) { (sucesso) in
                    if sucesso {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}
