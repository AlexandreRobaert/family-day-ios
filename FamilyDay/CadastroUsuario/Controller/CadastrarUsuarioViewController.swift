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
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    let generos: [String] = ["Masculino", "Feminino", "Outros"]
    var perfil: String!
    
    let formatData = DateFormatter()
    var dataSelecionada: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let toolbarGenero = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbarGenero.tintColor = UIColor(named: "Roxo")
        let buttonCancelar = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        let buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneGenero))
        let buttonSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbarGenero.items = [buttonCancelar, buttonSpace, buttonDone]
        
        generoTextField.inputView = tipoGeneroPicker
        generoTextField.inputAccessoryView = toolbarGenero
        
        let toolbarData = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbarData.tintColor = UIColor(named: "Roxo")
        let buttonDoneData = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneData))
        toolbarData.items = [buttonCancelar, buttonSpace, buttonDoneData]
        
        formatData.dateFormat = "dd/MM/yyyy"
        datePicker.datePickerMode = .date
        dataNascimentoTextField.inputView = datePicker
        dataNascimentoTextField.inputAccessoryView = toolbarData
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func cancel(){
        generoTextField.resignFirstResponder()
        dataNascimentoTextField.resignFirstResponder()
    }
    @objc func doneGenero(){
        generoTextField.text = generos[tipoGeneroPicker.selectedRow(inComponent: 0)]
        cancel()
    }
    
    @objc func doneData(){
        dataNascimentoTextField.text = formatData.string(from: datePicker.date)
        dataSelecionada = datePicker.date
        cancel()
    }
    
    func irParaTutorial(){
        
        navigationController?.dismiss(animated: false, completion: nil)
        let navigation = UINavigationController(rootViewController: Tela1ViewController())
        navigation.modalPresentationStyle = .fullScreen
        
        present(navigation, animated: true, completion: nil)
        
    }
    
    func salvarUsuario(){
        
        if !Utils.temTextFieldVazia(view: view){
            indicator.isHidden = false
            if let nome = nomeTextField.text, let email = emailTextField.text,
                let telefone = telefoneTextField.text, let senha = senhaTextField.text, let genero = generoTextField.text,
                let senhaRepetida = repetirSenhaTextField.text {
                
                var sexo = ""
                if genero.uppercased() == "MASCULINO"{
                    sexo = "M"
                }else if genero.uppercased() == "FEMININO"{
                    sexo = "F"
                }else{
                    sexo = "OUTROS"
                }
                
                if senha == senhaRepetida {
                    let user = Usuario(id: "", nome: nome, dataNascimento: dataSelecionada, telefone: telefone, tipo: perfil, email: email, genero: sexo, senha: senha)
                    UsuarioDao.cadastrarUsuario(user, deviceID: "DeviceInventado") { (user, arrayErros) in
                        if let _ = user?.id {
                            self.irParaTutorial()
                        }
                    }
                }else{
                    mensagemLabel.text = "Senha diferente do confirma senha!"
                    indicator.isHidden = true
                }
            }
        }else{
            mensagemLabel.text = "Todos os campos devem ser preenchidos corretamente"
            indicator.isHidden = true
        }
    }

    @IBAction func cadastrarUsuario(_ sender: UIButton) {
        salvarUsuario()
    }
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
