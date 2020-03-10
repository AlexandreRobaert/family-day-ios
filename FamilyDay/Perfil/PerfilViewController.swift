//
//  PerfilViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 03/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func abrirTelaCadastro(_ sender: UIButton) {
        if sender.tag == 0 {
            navigationController?.pushViewController(CadastroUsuarioViewController(), animated: true)
        }else{
            navigationController?.pushViewController(ScannerQRCodeViewController(), animated: true)
        }
    }
}
