//
//  CadastrarTarefaViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 14/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class CadastrarTarefaViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var descricaoTextField: UITextField!
    @IBOutlet weak var dataInicioTextField: UITextField!
    @IBOutlet weak var dataFimTextField: UITextField!
    @IBOutlet weak var pontosTextField: UITextField!
    @IBOutlet weak var metasTextField: UITextField!
    
    var switchTodoDia: UISwitch!
    var switchComprovacao: UISwitch!
    var detailTextDiasSemana = ""
    var detailTextMembros = ""
    var metasDaFamilia: [Meta] = []
    let listaDePontos = [1, 2, 5, 10, 20, 50, 100]
    var usuariosDaFamilia: [Usuario] = []
    
    var metaSelecionada: Meta?
    var diasSelecionados: [String] = []
    var usuariosSelecionados: [Usuario] = []
    var pontoSelecionado: Int = 0
    
    let formatData = DateFormatter()
    var datePickerInicio = UIDatePicker()
    var datePickerFim = UIDatePicker()
    
    lazy var pontosPicker: UIPickerView = {
        var picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }()
    
    lazy var metasPicker: UIPickerView = {
        var picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MetaDao.getMetasDaFamilia { (metas) in
            if let metas = metas {
                self.metasDaFamilia = metas
            }
        }
        
        UsuarioDao.getAllUsersFamily { (usuarios) in
            if let usuarios = usuarios {
                self.usuariosDaFamilia = usuarios
            }
        }
        
        configUI()
    }
    
    @objc func adicionarDataInicio() {
        dataInicioTextField.text = formatData.string(from: datePickerInicio.date)
    }
    @objc func adicionarDataFim() {
        dataFimTextField.text = formatData.string(from: datePickerFim.date)
    }
    
    
    func configUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DiaDaSemanaViewCell", bundle: nil), forCellReuseIdentifier: "cellTodoDia")
        tableView.register(UINib(nibName: "ComprovacaoViewCell", bundle: nil), forCellReuseIdentifier: "cellComprovacao")
        
        formatData.dateFormat = "dd/MM/yyyy"
        
        datePickerInicio.datePickerMode = .date
        datePickerInicio.minimumDate = Date()
        datePickerInicio.maximumDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
        datePickerInicio.addTarget(self, action: #selector(adicionarDataInicio), for: .valueChanged)
        dataInicioTextField.inputView = datePickerInicio
        dataInicioTextField.text = formatData.string(from: Date())
        
        datePickerFim.datePickerMode = .date
        datePickerFim.minimumDate = Date()
        datePickerFim.maximumDate = Calendar.current.date(byAdding: .month, value: 6, to: Date())
        datePickerFim.addTarget(self, action: #selector(adicionarDataFim), for: .valueChanged)
        dataFimTextField.inputView = datePickerFim
        
        pontosTextField.inputView = pontosPicker
        metasTextField.inputView = metasPicker
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let count = usuariosSelecionados.count
        if  count == 0 {
            detailTextMembros = "Nenhum"
        } else if count == 1 {
            detailTextMembros = "1 Membro"
        }else{
            detailTextMembros = "\(count) Membros"
        }
        
        if !diasSelecionados.isEmpty {
            detailTextDiasSemana = ""
            for dia in diasSelecionados {
                let index = dia.index(dia.startIndex, offsetBy: 3)
                detailTextDiasSemana.append(String(dia[..<index] + " "))
            }
        }else{
            detailTextDiasSemana = "Nenhum dia Selecionado"
        }
        tableView.reloadData()
    }
    
    @objc func mudouSwitchTodoDia() {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        
        cell?.isUserInteractionEnabled = !switchTodoDia.isOn
        cell?.textLabel?.isEnabled = !switchTodoDia.isOn
        cell?.detailTextLabel?.text = "Nenhum dia Selecionado"
        diasSelecionados.removeAll()
    }
    
    // MARK: - Ações
    @IBAction func salvarTarefa(_ sender: Any) {
        
        if !Utils.temTextFieldVazia(view: view){
            if !usuariosSelecionados.isEmpty {
                if switchTodoDia.isOn == false || diasSelecionados.isEmpty {
                    let alertControl = UIAlertController(title: "Em quais dias será executado?", message: "Você precisa me dizer se será todos os dias ou alguns dias da semana!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    alertControl.addAction(action)
                    self.navigationController?.present(alertControl, animated: true, completion: nil)
                }else{
                    let tarefa = Tarefa(id: "", titulo: tituloTextField.text!, descricao: descricaoTextField.text!, dataInicio: datePickerInicio.date, dataFim: datePickerFim.date, personalizado: diasSelecionados, diariamente: switchComprovacao.isOn, pontos: pontoSelecionado, exigeComprovacao: switchComprovacao.isOn)
                    
                    TarefaDao.cadastrarTarefa(tarefa: tarefa, meta: metaSelecionada!, usuarios: usuariosSelecionados) { (cadastrou) in
                        if cadastrou {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }else{
                let alertControl = UIAlertController(title: "Selecione um Membro!", message: "Você precisa selecionar pelos menos um membro da família para esta tarefa!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                alertControl.addAction(action)
                self.navigationController?.present(alertControl, animated: true, completion: nil)
            }
        }else{
            let alertControl = UIAlertController(title: "Campos Vazios", message: "Todos os campos devem ser preenchidos!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alertControl.addAction(action)
            self.navigationController?.present(alertControl, animated: true, completion: nil)
        }
    }
}

// MARK: - TableView Delegate DataSource
extension CadastrarTarefaViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTodoDia") as! DiaDaSemanaTableViewCell
            cell.selectionStyle = .none
            switchTodoDia = cell.uiSwitch
            switchTodoDia.addTarget(self, action: #selector(mudouSwitchTodoDia), for: .valueChanged)
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellDefault")
            cell.textLabel?.text = "Personalizar"
            cell.detailTextLabel?.text = detailTextDiasSemana
            cell.accessoryType = .disclosureIndicator
            return cell
        case 2:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellDefault")
            cell.textLabel?.text = "Para quem?"
            cell.detailTextLabel?.text = detailTextMembros
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellComprovacao") as! ComprovacaoTableViewCell
            cell.selectionStyle = .none
            switchComprovacao = cell.uiSwitch
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            let vc = DiasDaSemanaTableViewController()
            vc.delegate = self
            vc.diasSelecionados = diasSelecionados
            navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = ListaMembrosTableViewController()
            vc.delegate = self
            vc.usuarios = usuariosDaFamilia
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

extension CadastrarTarefaViewController: ListaDiasDelegate {
    func carregarListaDiasDaSemana(dias: [String]) {
        self.diasSelecionados = dias
    }
}

extension CadastrarTarefaViewController: ListaUsuarioDelegate {
    
    func adicionarUsuarioNaLista(user: Usuario) {
        //Não preciso implementar aqui
    }
    
    func carregarListaUsuario(users: [Usuario]) {
        self.usuariosSelecionados = users
    }
}

// MARK: - PickerView Delegate DataSource
extension CadastrarTarefaViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerView == pontosPicker ? listaDePontos.count : metasDaFamilia.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == pontosPicker {
            return listaDePontos[row] > 1 ? "\(listaDePontos[row]) Pontos" : "1 Ponto"
        }else{
            return metasDaFamilia[row].titulo
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pontosPicker {
            let pontos = listaDePontos[row]
            pontosTextField.text = pontos > 1 ? "\(listaDePontos[row]) Pontos" : "1 Ponto"
            pontoSelecionado = pontos
        }else{
            metasTextField.text = metasDaFamilia[row].titulo
            metaSelecionada = metasDaFamilia[row]
        }
    }
}