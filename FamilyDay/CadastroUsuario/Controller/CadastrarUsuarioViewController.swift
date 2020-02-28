//
//  CadastrarViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 06/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class CadastrarUsuarioViewController: UIViewController {

    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var dataNascimentoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func cadastrarUsuario(_ sender: UIButton) {
        
        if true {
            navigationController?.pushViewController(ConviteViewController(), animated: true)
        } else {
            let navigation = storyboard?.instantiateViewController(withIdentifier: "SegundoNavigationController") as! UINavigationController
            navigationController?.popToRootViewController(animated: false)
            navigationController?.dismiss(animated: false, completion: nil)
            present(navigation, animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
