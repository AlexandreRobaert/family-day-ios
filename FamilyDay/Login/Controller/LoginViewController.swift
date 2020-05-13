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
import FacebookLogin
import FBSDKLoginKit
import FirebaseUI
import GoogleSignIn
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var entrarButton: UIButton!
    @IBOutlet weak var criarContaButton: UIButton!
    @IBOutlet weak var mensagemLoginLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var viewCentral: UIView!
    @IBOutlet weak var redesSociaisStackView: UIStackView!
    
    
    let cornerRadiusButtons = CGFloat(integerLiteral: 15)
    let appleButton = ASAuthorizationAppleIDButton()
    let loginGoogleButton = GIDSignInButton()
    let facebookButton = FBLoginButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = Configuration.shared.token {
            print(token)
            getUser(for: token)
            entrarButton.isEnabled = false
            indicator.isHidden = false
            return
        }
        
        senhaTextField.delegate = self
        viewCentral.layer.shadowColor = UIColor.black.cgColor
        viewCentral.layer.shadowOpacity = 0.8
        viewCentral.layer.shadowOffset = .zero
        viewCentral.layer.shadowRadius = 5
        
        facebookButton.delegate = self
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        appleButton.addTarget(self, action: #selector(loginApple), for: .touchUpInside)
        
        redesSociaisStackView.autoresizesSubviews = true
        redesSociaisStackView.addSubview(appleButton)
        redesSociaisStackView.addSubview(facebookButton)
        redesSociaisStackView.addSubview(loginGoogleButton)
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(LoginViewController.receiveToggleAuthUINotification(_:)),
        name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil)
    }
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        
        if notification.name.rawValue == "ToggleAuthUINotification" {
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                let idToken = userInfo["idToken"]!
                print(idToken)
                self.validarTokenSocial(token: idToken)
            }
        }
    }
    
    @objc func loginApple(){
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func esqueciMinhaSenha(_ sender: UIButton) {
        
        navigationController?.pushViewController(RecuperarSenhaViewController(), animated: true)
    }
    
    func irParaHome(usuario: Usuario) {
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
    
    func validarTokenSocial(token: String){
        UsuarioDao.getToken(tokenSocial: token) { (token) in
            if let token = token {
                self.getUser(for: token)
            }
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
        textField.endEditing(true)
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { (auth, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            print("\(auth?.user.displayName) - \(auth?.user.phoneNumber)")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("sair da conta do Facebook")
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = "\(appleIDCredential.fullName?.givenName) \(appleIDCredential.fullName?.familyName)"
            let email = appleIDCredential.email
        
        case let passwordCredential as ASPasswordCredential:
            
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            break
        default:
            break
        }
        
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
