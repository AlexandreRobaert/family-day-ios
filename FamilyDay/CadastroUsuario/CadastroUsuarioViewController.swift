//
//  CadastroUsuarioViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 10/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit
import Alamofire

protocol FazerLoginDelegate {
    func fazerLogin(usuario: Usuario)
}

class CadastroUsuarioViewController: UIViewController {
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var apelidoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dataNascimentoTextField: UITextField!
    @IBOutlet weak var generoTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var repetirSenhaTextField: UITextField!
    @IBOutlet weak var mensagemLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var cadastrarButton: UIButton!
    @IBOutlet weak var imageHeader: UIImageView!
    @IBOutlet weak var viewCentral: UIView!
    
    var delegate: FazerLoginDelegate?
    let generos: [String] = ["Masculino", "Feminino", "Outros"]
    let formatData = DateFormatter()
    var dataSelecionada: Date = Date()
    var idade: Int = 0
    var usuario: Usuario?
    
    lazy var tipoGeneroPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        configUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func configUI(){
        
        viewCentral.layer.cornerRadius = 10
        viewCentral.layer.shadowColor = UIColor.black.cgColor
        viewCentral.layer.shadowOpacity = 0.8
        viewCentral.layer.shadowOffset = .zero
        viewCentral.layer.shadowRadius = 5
        
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
        
        if let usuario = usuario {
            cadastrarButton.tag = 1
            cadastrarButton.setTitle("Ativar Membro", for: .normal)
            imageHeader.image = UIImage(systemName: "person.crop.circle.badge.checkmark")
            nomeTextField.text = usuario.nome
            apelidoTextField.text = usuario.apelido ?? ""
            dataNascimentoTextField.text = formatData.string(from: usuario.dataNascimento!)
            emailTextField.text = usuario.email
            
            var genero = ""
            switch usuario.genero {
            case "M":
                genero = "MASCULINO"
            case "F":
                genero = "FEMININO"
            default:
                genero = "OUTROS"
            }
            generoTextField.text = genero
        }
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
        
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: dataSelecionada, to: now)
        idade = ageComponents.year!
        
        if idade < 18 && usuario == nil {
            mostrarAlertaDeIdade()
        }
    }
    
    func mostrarAlertaDeIdade(){
        let alert = UIAlertController(title: "Menores de Idade", message: "Menores de idade não podem utilizar este app sem a permissão do responsável", preferredStyle: .alert)
        let cancelar = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelar)
        present(alert, animated: true, completion: nil)
    }
    
    func irParaTutorial(idUsuario: String){
        
        let vc = Tela1ViewController()
        vc.idUsuario = idUsuario
        navigationController?.viewControllers = [vc]
        navigationController?.popToRootViewController(animated: true)
    }
    
    func salvarUsuario(){
        
        for textField in Utils.getTextfield(view: view) {
            textField.layer.borderWidth = 0.0
        }
        
        cadastrarButton.isEnabled = false
        if !Utils.temTextFieldVazia(view: view){
            indicator.isHidden = false
            if let nome = nomeTextField.text, let email = emailTextField.text, let nick = apelidoTextField.text,
               let senha = senhaTextField.text, let genero = generoTextField.text,
                let senhaRepetida = repetirSenhaTextField.text {
                
                var sexo = ""
                if genero.uppercased() == "MASCULINO" {
                    sexo = "M"
                }else if genero.uppercased() == "FEMININO"{
                    sexo = "F"
                }else{
                    sexo = "OUTRO"
                }
                
                if senha == senhaRepetida {
                    
                    if cadastrarButton.tag == 0 {
                        let user = Usuario(id: "", nome: nome, dataNascimento: dataSelecionada, tipo: "RESPONSAVEL", email: email, genero: sexo, senha: senha, idFamilia: "", ativo: true)
                        
                        UsuarioDao.cadastrarUsuario(user, deviceID: Configuration.shared.deviceId!) { (idUsuario, mensagemErro) in
                            if let id = idUsuario  {
                                self.irParaTutorial(idUsuario: id)
                            }else{
                                self.cadastrarButton.isEnabled = true
                                self.indicator.isHidden = true
                                self.mensagemLabel.text = mensagemErro!
                            }
                        }
                    }else{
                        if var usuario = usuario {
                            usuario.nome = nome
                            usuario.apelido = nick
                            usuario.email = email
                            usuario.senha = senha
                            usuario.ativo = true
                            usuario.dataNascimento = dataSelecionada
                            usuario.genero = sexo
                            UsuarioDao.atualizarUsuario(usuario, deviceID: Configuration.shared.deviceId!) { (idUsuario, erros) in
                                if idUsuario != nil {
                                    self.dismiss(animated: true, completion: nil)
                                    self.delegate?.fazerLogin(usuario: usuario)
                                }
                            }
                        }
                    }
                }else{
                    cadastrarButton.isEnabled = true
                    mensagemLabel.text = "Senha diferente do confirma senha!"
                    indicator.isHidden = true
                }
            }
        }else{
            cadastrarButton.isEnabled = true
            mensagemLabel.text = "Todos os campos devem ser preenchidos corretamente"
            indicator.isHidden = true
        }
    }
    
    @IBAction func cadastrarUsuario(_ sender: UIButton) {
        
        if idade > 18 || idade == 0 || usuario != nil{
            salvarUsuario()
        }else{
            mostrarAlertaDeIdade()
        }
    }
}

// MARK: - Delegate PickerView
extension CadastroUsuarioViewController: UIPickerViewDataSource, UIPickerViewDelegate {
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

extension CadastroUsuarioViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case nomeTextField:
            dataNascimentoTextField.becomeFirstResponder()
        case emailTextField:
            dataNascimentoTextField.becomeFirstResponder()
        case dataNascimentoTextField:
            generoTextField.becomeFirstResponder()
        case generoTextField:
            senhaTextField.becomeFirstResponder()
        case senhaTextField:
            repetirSenhaTextField.resignFirstResponder()
        case repetirSenhaTextField:
            view.endEditing(true)
        default:
            print()
        }
        
        return true
    }
}
