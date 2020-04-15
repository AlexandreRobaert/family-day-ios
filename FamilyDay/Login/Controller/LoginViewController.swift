//
//  LoginViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 05/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var entrarButton: UIButton!
    @IBOutlet weak var criarContaButton: UIButton!
    @IBOutlet weak var mensagemLoginLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewCentral: UIView!
    
    let cornerRadiusButtons = CGFloat(integerLiteral: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCentral.layer.shadowColor = UIColor.black.cgColor
        viewCentral.layer.shadowOpacity = 0.8
        viewCentral.layer.shadowOffset = .zero
        viewCentral.layer.shadowRadius = 5
        
        if let token = Configuration.shared.token {
            getUser(for: token)
            entrarButton.isEnabled = false
            indicator.isHidden = false
            return
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func irParaHome(usuario: Usuario){
        dismiss(animated: false, completion: nil)
        let tab = self.storyboard?.instantiateViewController(withIdentifier: "tabbarhome") as! UITabBarController
        let navigation = tab.viewControllers?.first as! UINavigationController
        let vcHome = navigation.viewControllers[0] as! HomeViewController
        vcHome.user = usuario

        self.navigationController?.dismiss(animated: false, completion: nil)
        self.present(tab, animated: true, completion: nil)
    }
    
    func getUser(for token: String){
        UsuarioDao.getUserfor(token: token) { (usuario) in
            self.entrarButton.isEnabled = true
            if let usuario = usuario {
                self.irParaHome(usuario: usuario)
            }else{
                self.mensagemLoginLabel.text = "Usuário Não Encontrado"
            }
            self.indicator.isHidden = true
        }
    }

    @IBAction func login(_ sender: UIButton) {
        mensagemLoginLabel.text = ""
        indicator.isHidden = false
        entrarButton.isEnabled = false
        
        if let login = loginTextField.text, !login.isEmpty, let senha = senhaTextField.text, !senha.isEmpty {
            UsuarioDao.getToken(login: login, senha: senha) { (token) in
                self.entrarButton.isEnabled = true
                if let token = token {
                    self.getUser(for: token)
                    self.indicator.isHidden = true
                }else{
                    self.mensagemLoginLabel.text = "Login Inválido"
                    self.indicator.isHidden = true
                }
            }
        }else{
            self.entrarButton.isEnabled = true
            self.mensagemLoginLabel.text = "Campo Login e Senha devem ser preenchidos!"
            self.indicator.isHidden = true
        }
    }
    
    @IBAction func abrirTelaQRCode(_ sender: UIButton) {
        let vc = ScannerQRCodeViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LoginViewController: FazerLoginDelegate {
    
    func fazerLogin(usuario: Usuario) {
        irParaHome(usuario: usuario)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}
