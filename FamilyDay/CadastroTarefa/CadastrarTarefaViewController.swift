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
    
    var uiSwitch: UISwitch!
    var detailTextDiasSemana = ""
    var detailTextMembros = ""
    var metasDaFamilia: [Meta] = []
    var usuariosDaFamilia: [Usuario] = []
    
    var metaSelecionada: Meta?
    var diasSelecionados: [String] = []
    var usuariosSelecionados: [Usuario] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DiaDaSemanaViewCell", bundle: nil), forCellReuseIdentifier: "cellTodoDia")
        
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
    
    @objc func mudouSwitch() {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 0))
        
        cell?.isUserInteractionEnabled = !uiSwitch.isOn
        cell?.textLabel?.isEnabled = !uiSwitch.isOn
    }
}

// MARK: - TableView Delegate DataSource
extension CadastrarTarefaViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellTodoDia") as! DiaDaSemanaTableViewCell
            cell.selectionStyle = .none
            uiSwitch = cell.uiSwitch
            uiSwitch.addTarget(self, action: #selector(mudouSwitch), for: .valueChanged)
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellDefault")
            cell.textLabel?.text = "Personalizar"
            cell.detailTextLabel?.text = detailTextDiasSemana
            cell.accessoryType = .disclosureIndicator
            return cell
        default:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cellDefault")
            cell.textLabel?.text = "Para quem?"
            cell.detailTextLabel?.text = detailTextMembros
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("Todos os dias")
            print(uiSwitch.isOn)
        case 1:
            let vc = DiasDaSemanaTableViewController()
            vc.delegate = self
            vc.diasSelecionados = diasSelecionados
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = ListaMembrosTableViewController()
            vc.delegate = self
            vc.usuarios = usuariosDaFamilia
            navigationController?.pushViewController(vc, animated: true)
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
