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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func cadastrarUsuario(_ sender: UIButton) {
        cadastrar { (retorno, statusCode) in
            if statusCode >= 400 {
                let mensagem = retorno!["mensagem"]
                let arrayMensagens = retorno!["motivo"] as! Array<String>
                print("\(mensagem!) \(arrayMensagens[0])")
            }else{
                let token = retorno!["token"]
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
    
    func cadastrar(completion: @escaping([String: Any]?, Int) -> Void){
        if let nome = nomeTextField.text, let data = dataNascimentoTextField.text, let email = emailTextField.text,
            let telefone = telefoneTextField.text, let senha = senhaTextField.text, let senhaRepetida = repetirSenhaTextField.text {
            
            if senha == senhaRepetida {
                let user = Usuario(id: "", nome: nome, dataNascimento: Date(), telefone: telefone, tipo: "frverg", email: email, genero: "M", senha: senha)
                
                let headers: HTTPHeaders = ["x-access-token": Configuration.shared.token]
                
                let fullISO8610Formatter = DateFormatter()
                fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                let stringData = fullISO8610Formatter.string(from: user.dataNascimento!)
                
                let parametros = ["nome": user.nome, "dataNascimento": stringData, "telefone": user.telefone, "tipo": user.tipo, "genero": user.genero, "email": user.email, "senha": user.senha, "os": "IOS", "deviceId": "chakdjalsd"]
                
                AF.request("\(Configuration.URL_API)usuarios", method: .post, parameters: parametros, headers: headers).responseJSON { (response) in
                    switch response.result {
                    case .success(let result as [String: Any]):
                        completion(result, response.response!.statusCode)
                    case .success(_):
                        print("s")
                    case .failure(let error):
                        print(error.responseContentType)
                    }
                }
                
            }else{
                mensagemLabel.text = "Todos os campos devem serem preenchidos corretamente!"
            }
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
