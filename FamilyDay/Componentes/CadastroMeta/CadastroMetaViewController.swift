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

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var descricaoTextField: UITextField!
    @IBOutlet weak var pontosTextField: UITextField!
    @IBOutlet weak var tituloDaTelaLabel: UILabel!
    @IBOutlet weak var cadastrarButton: UIButton!
    
    var meta: Meta?
    var delegate: TabelaMetasDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
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
        }
    }

    @IBAction func cadastrarMeta(_ sender: Any) {
        
        for textField in Utils.getTextfield(view: view) {
            textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        if !Utils.temTextFieldVazia(view: view){
            
            self.meta = Meta(id: nil, titulo: tituloTextField.text!, descricao: descricaoTextField.text!, pontosAlvo: (pontosTextField.text! as NSString).integerValue)
            
            if cadastrarButton.tag == 111 {
                MetaDao.cadastrarMeta(meta: meta!) { (idMeta) in
                    if let id = idMeta {
                        self.meta?.id = id
                        self.delegate?.atualizarTabelaDeMetas(meta: self.meta!)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }else{
                MetaDao.atualizarMeta(meta: meta!) { (sucesso) in
                    if sucesso {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}