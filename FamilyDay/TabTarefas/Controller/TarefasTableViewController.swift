//
//  TarefasTableViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 29/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class TarefasTableViewController: UITableViewController {
    
    @IBOutlet weak var dataFiltroLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var tarefas: [Tarefa] = []
    var status: StatusTarefa!
    var dataInicio: Date!
    var dataFim: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatData = DateFormatter()
        formatData.dateFormat = "dd-MM-yyyy"
        dataFiltroLabel.text = ""
        if status != nil {
            dataFiltroLabel.text = "Data: \(formatData.string(from: dataInicio)) até \(formatData.string(from: dataFim))"
        }
        mudarTituloTela()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        indicator.isHidden = false
        super.viewWillAppear(animated)
        let responsavel = Configuration.shared.usuarioResponsavel!
        TarefaDao.getTarefas(usuarioEResponsavel: responsavel, entre: dataInicio, ate: dataFim, status: status, completion: { (tarefas) in
            self.tarefas = tarefas
            self.tableView.reloadData()
            self.indicator.isHidden = true
        })
    }
    
    func mudarTituloTela(){
        switch status {
        case .validacao:
            navigationItem.title = "Aguardando Aprovação"
        case .pendente:
            navigationItem.title = "Á Fazer"
        case .aprovado:
            navigationItem.title = "Feita"
        case .reprovado:
            navigationItem.title = "Reprovada"
        default:
            navigationItem.title = "Outros"
        }
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return tarefas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TarefaTableViewCell
        cell.configuraCell(tarefa: tarefas[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetalhesTarefaViewController()
        vc.tarefa = tarefas[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
}
