//
//  RecuperarSenhaViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 20/04/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit
import SCLAlertView

class RecuperarSenhaViewController: UIViewController {
    
    @IBOutlet weak var viewCentral: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var enviarButton: UIButton!
    @IBOutlet weak var descricaoDaTela: UILabel!
    @IBOutlet weak var senhaTextfield: UITextField!
    @IBOutlet weak var repetirSenhaTextField: UITextField!
    
    var emailNick: String = ""
    var codigo: String = ""
    var novaSenha: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCentral.layer.cornerRadius = 10
        viewCentral.layer.shadowColor = UIColor.black.cgColor
        viewCentral.layer.shadowOpacity = 0.8
        viewCentral.layer.shadowOffset = .zero
        viewCentral.layer.shadowRadius = 5
        
        emailTextField.delegate = self
        repetirSenhaTextField.delegate = self
        self.enviarButton.addTarget(self, action: #selector(self.enviarEmail), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func mudarSenha(){
        if let senha = senhaTextfield.text, let senhaRepete = repetirSenhaTextField.text, senha == senhaRepete {
            UsuarioDao.atualizarSenha(emailOuNick: emailNick, codigo: codigo, senha: senha.trimmingCharacters(in: .whitespacesAndNewlines)) { (mudou) in
                if mudou {
                    self.navigationController?.popToRootViewController(animated: true)
                }else{
                    SCLAlertView().showCustom("Código Inválido", subTitle: "Você informou um código inválido!", color: .purple, icon: UIImage(systemName: "lock.fill")!)
                }
            }
        }
    }
    
    @objc func virificarCodigo() {
        if let codigo = emailTextField.text, !codigo.isEmpty {
            self.codigo = codigo.trimmingCharacters(in: .whitespacesAndNewlines)
            UsuarioDao.validarCodigoRecuperacao(emailNick: emailNick, codigo: self.codigo) { (valido) in
                if valido {
                    self.descricaoDaTela.text = "Agora você poderá alterar sua senha. Vamos lá"
                    self.emailTextField.isHidden = true
                    self.senhaTextfield.isHidden = false
                    self.repetirSenhaTextField.isHidden = false
                    self.enviarButton.setTitle("Salvar", for: .normal)
                    self.enviarButton.removeTarget(self, action: #selector(self.virificarCodigo), for: .touchUpInside)
                    self.enviarButton.addTarget(self, action: #selector(self.mudarSenha), for: .touchUpInside)
                }else{
                    SCLAlertView().showCustom("Código Inválido", subTitle: "Você informou um código inválido!", color: .purple, icon: UIImage(systemName: "lock.fill")!)
                }
            }
        }else{
            SCLAlertView().showCustom("Código Inválido", subTitle: "Você não informou o código!", color: .purple, icon: UIImage(systemName: "lock.fill")!)
        }
    }
    
    @objc func enviarEmail() {
        if let emailNick = emailTextField.text, !emailNick.isEmpty {
            self.emailNick = emailNick.trimmingCharacters(in: .whitespacesAndNewlines)
            UsuarioDao.enviarEmailRecuperarSenha(emailNick: self.emailNick) { (email, mensagemErro) in
                if let email = email {
                    self.emailTextField.placeholder = "Código"
                    self.emailTextField.textAlignment = .center
                    self.emailTextField.text = ""
                    self.emailTextField.font = UIFont(name: "Futura", size: 30)
                    self.descricaoDaTela.text = "Acabamos de enviar um código para o e-mail \(email). Não esqueça de verificar sua caixa de spam e lixo eletrônico."
                    self.enviarButton.removeTarget(self, action: #selector(self.enviarEmail), for: .touchUpInside)
                    self.enviarButton.addTarget(self, action: #selector(self.virificarCodigo), for: .touchUpInside)
                }else{
                    SCLAlertView().showCustom("Email Inválido ou não cadastrado", subTitle: "Você deve me informar seu email", color: .purple, icon: UIImage(systemName: "paperplane.fill")!)
                }
            }
        }else{
            SCLAlertView().showCustom("Email Inválido", subTitle: "Você deve me informar seu email", color: .purple, icon: UIImage(systemName: "paperplane.fill")!)
        }
    }
}

extension RecuperarSenhaViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
    }
}
