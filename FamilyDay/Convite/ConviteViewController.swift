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
    }

    @IBAction func convidar(_ sender: UIButton) {
        guard let nome = nomeTextField.text else {return}
        guard let email = emailTextfield.text else {return}
        guard let telefone = telefoneTextField.text else {return}
        
        let items = ["Olá \(nome) nosso aplicativos para baixar \(URL(string: "https://apps.apple.com/br/app/township/id781424368?mt=12")!)"]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }

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
