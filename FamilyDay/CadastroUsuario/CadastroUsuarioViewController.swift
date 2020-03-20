//
//  CadastroUsuarioViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 10/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit
import Alamofire

class CadastroUsuarioViewController: UIViewController {
    
    @IBOutlet weak var nomeTextField: UITextField!
    @IBOutlet weak var dataNascimentoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var telefoneTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var repetirSenhaTextField: UITextField!
    @IBOutlet weak var mensagemLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var generoTextField: UITextField!
    @IBOutlet weak var cadastrarButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    lazy var tipoGeneroPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()
    
    var datePicker: UIDatePicker = UIDatePicker()
    
    let generos: [String] = ["Masculino", "Feminino", "Outros"]
    
    let formatData = DateFormatter()
    var dataSelecionada: Date = Date()
    var idade: Int = 0
    
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
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        print("Entrou")
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        scrollView.scrollIndicatorInsets = scrollView.contentInset

//        let selectedRange = scrollView.selectedRange
//        scrollView.scrollRangeToVisible(selectedRange)
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
        
        let now = Date()
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: dataSelecionada, to: now)
        idade = ageComponents.year!
        
        if idade < 18 {
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
        
        navigationController?.dismiss(animated: false, completion: nil)
        let vc = Tela1ViewController()
        vc.idUsuario = idUsuario
        let navigation = UINavigationController(rootViewController: vc)
        navigation.modalPresentationStyle = .fullScreen
        
        present(navigation, animated: true, completion: nil)
        
    }
    
    func salvarUsuario(){
        
        for textField in Utils.getTextfield(view: view) {
            textField.layer.borderWidth = 0.0
        }
        
        cadastrarButton.isEnabled = false
        if !Utils.temTextFieldVazia(view: view){
            indicator.isHidden = false
            if let nome = nomeTextField.text, let email = emailTextField.text,
                let telefone = telefoneTextField.text, let senha = senhaTextField.text, let genero = generoTextField.text,
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
                    let user = Usuario(id: "", nome: nome, dataNascimento: dataSelecionada, telefone: telefone, tipo: "RESPONSAVEL", email: email, genero: sexo, senha: senha, idFamilia: "")
                    UsuarioDao.cadastrarUsuario(user, deviceID: "DeviceInventado") { (idUsuario, mensagemErro) in
                        if let id = idUsuario  {
                            self.irParaTutorial(idUsuario: id)
                        }else{
                            self.cadastrarButton.isEnabled = true
                            self.indicator.isHidden = true
                            self.mensagemLabel.text = mensagemErro!
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
        if idade > 18 || idade == 0 {
            salvarUsuario()
        }else{
            mostrarAlertaDeIdade()
        }
    }
}

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
