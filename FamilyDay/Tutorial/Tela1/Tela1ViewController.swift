//
//  Tela1ViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 27/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class Tela1ViewController: UIViewController {

    @IBOutlet weak var nomeGrupoTextField: UITextField!
    
    var idUsuario: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nomeGrupoTextField.delegate = self
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    @IBAction func irParaSegundaTela(_ sender: UIButton) {
        let vc = Tela2ViewController()
        vc.nomeGrupo = nomeGrupoTextField.text
        vc.idUsuario = idUsuario
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension Tela1ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
