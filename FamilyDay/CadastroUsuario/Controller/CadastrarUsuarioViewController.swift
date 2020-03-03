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
    
    
    lazy var tipoGeneroPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    let generos: [String] = ["Masculino", "Feminino", "Outros"]
    var perfil: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "Roxo")
        let buttonCancelar = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let buttonSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [buttonCancelar, buttonSpace, buttonDone]
        
        generoTextField.inputView = tipoGeneroPicker
        generoTextField.inputAccessoryView = toolbar
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    @objc func cancel(){
        generoTextField.resignFirstResponder()
    }
    @objc func done(){
        generoTextField.text = generos[tipoGeneroPicker.selectedRow(inComponent: 0)]
        cancel()
    }

    @IBAction func cadastrarUsuario(_ sender: UIButton) {
        indicator.isHidden = false
        if let nome = nomeTextField.text, let data = dataNascimentoTextField.text, let email = emailTextField.text,
            let telefone = telefoneTextField.text, let senha = senhaTextField.text, let genero = generoTextField.text,
            let senhaRepetida = repetirSenhaTextField.text {
            
            if senha == senhaRepetida {
                let user = Usuario(id: "", nome: nome, dataNascimento: Date(), telefone: telefone, tipo: perfil, email: email, genero: genero, senha: senha)
                UsuarioDao.cadastrarUsuario(user, deviceID: "DeviceID teste") { (retorno) in
                    switch retorno {
                    case .Sucesso:
                        //Fazer algo depois que cadastrou
                        print("Novo Usuario: \(Configuration.shared.token)")
                        break
                    case .Falha:
                        //Dizer algo se não cadastrar
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

extension CadastrarUsuarioViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return generos[row]
    }
}
