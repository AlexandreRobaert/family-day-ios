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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            getToken(login: login, senha: senha) { (resultado) in
                switch resultado {
                case .success(let value):
                    if let token = value["token"] {
                        Configuration.shared.token = token as! String
                        self.getUserfor(token: token as! String) { (usuario) in
                            if let user = usuario {
                                self.irParaHome(usuario: user)
                            }
                        }
                    }else{
                        self.mensagemLoginLabel.text = "Login inválido!"
                        self.indicator.isHidden = true
                    }
                case .failure(_):
                    print("Falha")
                }
            }
        }else{
            mensagemLoginLabel.text = "Todos os campos devem ser preenchidos."
        }
    }
    
    func getToken(login: String, senha: String, completion: @escaping (AFResult<[String: Any]>) -> Void){
        
        let headers: HTTPHeaders = [.authorization(username: login, password: senha)]

        AF.request("\(Configuration.URL_API)login", method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value as [String: Any]):
                completion(.success(value))
                break
            case .success(_):
                print("Sucesso sem usuário")
            case .failure(_):
                print("Falha!")
            }
        }
    }
    
    func getUserfor(token: String, completion: @escaping (Usuario?) -> Void) -> Void {
        let headers: HTTPHeaders = ["x-access-token": token]
        
        AF.request("\(Configuration.URL_API)usuarios/me", headers: headers).validate().responseDecodable(of: Usuario.self) {(response) in
            print(response.result)
            switch response.result {
            case .success(let usuario):
                completion(usuario)
            case .failure(_):
                print("Error ao buscar usuário")
            }
        }
    }
}
