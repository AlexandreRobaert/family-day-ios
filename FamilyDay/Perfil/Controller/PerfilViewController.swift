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

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "segueTelaCadastro"{
            let telaCadastro = segue.destination as! CadastrarUsuarioViewController
            if let button: UIButton = sender as? UIButton {
                if button.tag == 0 {
                    telaCadastro.perfil = "RESPONSAVEL"
                }else{
                    telaCadastro.perfil = "DEPENDENTE"
                }
            }
        }else{
            //Iniciar a tela de convide para o Dependente
        }
    }
    
    @IBAction func abrirTelaCadastro(_ sender: UIButton) {
        if sender.tag == 0 {
            performSegue(withIdentifier: "segueTelaCadastro", sender: sender)
        }else{
            //Iniciar Outra Segue
        }
    }
}
