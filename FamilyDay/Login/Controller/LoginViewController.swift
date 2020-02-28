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

    @IBAction func login(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
        
        indicator.isHidden = false
//        if let login = loginTextField.text, let senha = senhaTextField.text {
//            fazerLogin(login: login, senha: senha) { (resultado) in
//                switch resultado {
//                case .success(let value):
//                    if let token = value["token"] {
//                        print(token)
//                        self.indicator.isHidden = true
//                    }
//                case .failure(_):
//                    print("Falha")
//                }
//            }
//        }
        
        
        let navigation = storyboard?.instantiateViewController(withIdentifier: "SegundoNavigationController") as! UINavigationController
        let tab = navigation.viewControllers.first as! UITabBarController
        let vcHome = tab.viewControllers?.first as! HomeViewController
        vcHome.textoRecuperado = "Texto Passado"

        navigationController?.dismiss(animated: false, completion: nil)
        present(navigation, animated: true, completion: nil)
        
    }
    
    func fazerLogin(login: String, senha: String, completion: @escaping (AFResult<[String: Any]>) -> Void){
        
        let headers: HTTPHeaders = [.authorization(username: login, password: senha)]

        AF.request("https://api-family-day.herokuapp.com/api/login", method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value as [String: Any]):
                completion(.success(value))
            case .success(_):
                print("Sucesso")
            case .failure(_):
                print("Falha")
            }
        }
    }
}
