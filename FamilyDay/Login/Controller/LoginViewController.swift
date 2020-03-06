//
//  LoginViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 05/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var entrarButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var criarContaButton: UIButton!
    @IBOutlet weak var mensagemLoginLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    let cornerRadiusButtons = CGFloat(integerLiteral: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        criarContaButton.layer.borderWidth = 2
        criarContaButton.layer.borderColor = UIColor(named: "Roxo")?.cgColor
       
        print(Configuration.shared.token)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func irParaHome(usuario: Usuario){
        dismiss(animated: false, completion: nil)
        let navigation = self.storyboard?.instantiateViewController(withIdentifier: "SegundoNavigationController") as! UINavigationController
        let tab = navigation.viewControllers.first as! UITabBarController
        let vcHome = tab.viewControllers?.first as! HomeViewController
        vcHome.user = usuario

        self.navigationController?.dismiss(animated: false, completion: nil)
        self.present(navigation, animated: true, completion: nil)
    }

    @IBAction func login(_ sender: UIButton) {
        mensagemLoginLabel.text = ""
        indicator.isHidden = false
        
        if let login = loginTextField.text, let senha = senhaTextField.text {
            
            UsuarioDao.getToken(login: "alexandrenet.robaert@gmail.com", senha: "psl159357") { (token) in
                if let token = token {
                    UsuarioDao.getUserfor(token: token) { (usuario) in
                        if let usuario = usuario {
                            self.irParaHome(usuario: usuario)
                        }else{
                            self.mensagemLoginLabel.text = "Usuário Não Encontrado"
                        }
                    }
                }else{
                    self.mensagemLoginLabel.text = "Login Inválido"
                }
            }
        }else{
            self.mensagemLoginLabel.text = "Todos os campos devem ser preenchidos"
        }
        self.indicator.isHidden = true
    }
}
