//
//  CadastrarViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 06/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit
import Alamofire

class CadastrarUsuarioViewController: UIViewController {

    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var dataNascimentoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var repetirSenhaTextField: UITextField!
    @IBOutlet weak var mensagemLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var generoTextField: UITextField!
    @IBOutlet weak var tipoPerfilTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func cadastrarUsuario(_ sender: UIButton) {
        indicator.isHidden = false
        if let nome = nomeTextField.text, let data = dataNascimentoTextField.text, let email = emailTextField.text,
            let telefone = telefoneTextField.text, let senha = senhaTextField.text, let genero = generoTextField.text,
            let senhaRepetida = repetirSenhaTextField.text, let tipoPerfil = tipoPerfilTextField.text {
            
            if senha == senhaRepetida {
                let user = Usuario(id: "", nome: nome, dataNascimento: Date(), telefone: telefone, tipo: tipoPerfil, email: email, genero: genero, senha: senha)
                UsuarioDao.cadastrarUsuario(user, deviceID: "DeviceID teste") { (retorno) in
                    switch retorno {
                    case .Cadastrou:
                        //Fazer algo depois que cadastrou
                        print("Novo Usuario: \(Configuration.shared.token)")
                        break
                    case .Falha:
                        //Dizer algo se náo cadastrar
                        break
                    }
                    self.indicator.isHidden = true
                }
            }else{
                mensagemLabel.text = "Todos os campos devem serem preenchidos corretamente!"
            }
        }
        
        if true {
            //navigationController?.pushViewController(ConviteViewController(), animated: true)
//            navigationController?.popToRootViewController(animated: false)
//            navigationController?.viewControllers.removeAll()
//            navigationController?.dismiss(animated: false, completion: nil)
//            let navigation = UINavigationController(rootViewController: Tela1ViewController())
//            navigation.modalPresentationStyle = .fullScreen
//            present(navigation, animated: true, completion: nil)
            
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
