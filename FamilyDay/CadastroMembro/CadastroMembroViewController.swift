//
//  CadastroMembroViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 06/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class CadastroMembroViewController: UIViewController {

    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var dataNascimentoTextField: UITextField!
    @IBOutlet weak var generoTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    @IBOutlet weak var perfilTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var mensagemLabel: UILabel!
    
    lazy var tipoGeneroPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    lazy var tipoPerfilPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    let datePicker = UIDatePicker()
    let formatData = DateFormatter()
    var dataSelecionada: Date = Date()
    let generos: [String] = ["Masculino", "Feminino", "Outros"]
    let tipoPerfil = ["DEPENDENTE", "RESPONSAVEL"]
    
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
        
        let toolbarTipoPerfil = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbarTipoPerfil.tintColor = UIColor(named: "Roxo")
        let buttonDonePerfil = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTipoPerfil))
        toolbarTipoPerfil.items = [buttonCancelar, buttonSpace, buttonDonePerfil]
        perfilTextField.inputView = tipoPerfilPicker
        perfilTextField.inputAccessoryView = toolbarTipoPerfil
    }
    
    @objc func cancel(){
        generoTextField.resignFirstResponder()
        dataNascimentoTextField.resignFirstResponder()
        perfilTextField.resignFirstResponder()
    }
    
    @objc func doneGenero(){
        generoTextField.text = generos[tipoGeneroPicker.selectedRow(inComponent: 0)]
        cancel()
    }
    
    @objc func doneTipoPerfil() {
        perfilTextField.text = tipoPerfil[tipoPerfilPicker.selectedRow(inComponent: 0)]
        cancel()
    }
    
    @objc func doneData(){
        dataNascimentoTextField.text = formatData.string(from: datePicker.date)
        dataSelecionada = datePicker.date
        cancel()
    }
    
    func criarUsuario(){
       
        if !Utils.temTextFieldVazia(view: view){
            if let nome = nomeTextField.text, let genero = generoTextField.text,
                let telefone = telefoneTextField.text, let perfil = perfilTextField.text, let email = telefoneTextField.text {
                
                var sexo = ""
                if genero.uppercased() == "MASCULINO"{
                    sexo = "M"
                }else if genero.uppercased() == "FEMININO"{
                    sexo = "F"
                }else{
                    sexo = "OUTROS"
                }
                
                let user = Usuario(id: "nome", nome: nome, dataNascimento: dataSelecionada, telefone: telefone, tipo: perfil, email: email, genero: sexo, senha: "")
                
                MembroDao.cadastrarMembro(usuario: user, idFamilia: Configuration.shared.idFamilia) { (token) in
                    if let token = token {
                        print(token)
                    }
                }
            }
        }else{
            mensagemLabel.text = "Todos os campos devem ser preenchidos!"
        }
    }
    
    @IBAction func cadastrarMembro(_ sender: Any) {
        mensagemLabel.text = ""
        for textField in Utils.getTextfield(view: view) {
            textField.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textField.layer.borderWidth = 0.0
        }
        criarUsuario()
    }
}

extension CadastroMembroViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerView == tipoGeneroPicker ? generos.count : tipoPerfil.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return pickerView == tipoGeneroPicker ? generos[row] : tipoPerfil[row]
    }
}
