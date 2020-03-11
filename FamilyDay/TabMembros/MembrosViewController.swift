//
//  MembrosViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 11/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class MembrosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func telaNovoMembro(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(CadastroMembroViewController(), animated: true)
    }
}
