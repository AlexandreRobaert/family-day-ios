//
//  ConviteViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 18/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class ConviteViewController: UIViewController {

    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    
    let mensagem: Mensagem = Mensagem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.delegate = self
        telefoneTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    @IBAction func convidar(_ sender: UIButton) {
        guard let nome = nomeTextField.text else {return}
        guard let email = emailTextfield.text else {return}
        guard let telefone = telefoneTextField.text else {return}
        
        let usuario = Usuario(id: "", nome: nome, dataNascimento: Date(), telefone: telefone, tipo: "", email: email, genero: "", senha: "")
        
        abrirMenu(usuario: usuario)
    }
    
    func abrirMenu(usuario: Usuario){
        let menu = MenuDeOpcoesEnvio().configuraMenuOpcoes { (opcao) in
            switch opcao {
            case .sms:
                if let componenteMensagem = self.mensagem.configuraSMS(usuario: usuario){
                    componenteMensagem.messageComposeDelegate = self.mensagem
                    self.present(componenteMensagem, animated: true, completion: nil)
                }
                break
            
            case .whatsapp:
                
                guard let urlString = "https://wa.me/+55\(usuario.telefone)?text=\(usuario.nome), Meu texto de convite do app Whatsapp de Family Day".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {return}
                print(urlString)
                if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }else{
                    print("Não Abre o WHATSAPP")
                }
                self.navigationController?.popToRootViewController(animated: false)
                break
            }
        }
        self.present(menu, animated: true, completion: nil)
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

extension ConviteViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == telefoneTextField {
            emailTextfield.becomeFirstResponder()
        }else{
            textField.resignFirstResponder()
        }
        return true
    }
    
}
