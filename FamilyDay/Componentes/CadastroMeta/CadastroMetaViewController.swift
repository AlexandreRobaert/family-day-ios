//
//  CadastroMetaViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 09/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class CadastroMetaViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var descricaoTextField: UITextField!
    @IBOutlet weak var pontosTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image.image = Utils.generateQRCode(from: "https://apps.apple.com/br/app/altos-odyssey/id1495097700?mt=12")
    }
    
    func criarMeta() -> Meta?{
        if !Utils.temTextFieldVazia(view: view){
            let meta = Meta(id: nil, titulo: tituloTextField.text!, descricao: descricaoTextField.text!, pontos: (pontosTextField.text! as NSString).integerValue)
            return meta
        }
        return nil
    }
    

    @IBAction func cadastrarMeta(_ sender: Any) {
        
        for textField in Utils.getTextfield(view: view) {
            textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        if let meta = criarMeta() {
            MetaDao.cadastrarMeta(meta: meta, idFamilia: Configuration.shared.idFamilia) { (retorno) in
                print("CadastrarMeta")
            }
        }
    }
}
