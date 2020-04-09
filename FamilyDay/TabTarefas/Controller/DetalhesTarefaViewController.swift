//
//  DetalhesTarefaViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 12/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class DetalhesTarefaViewController: UIViewController {

    @IBOutlet weak var tituloLabel: UILabel!
    @IBOutlet weak var pontosLabel: UILabel!
    @IBOutlet weak var dataFimLabel: UILabel!
    @IBOutlet weak var tituloMetaLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tarefa: Tarefa!
    var historicos: [Historico] = []
    let formatData = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        formatData.dateFormat = "dd/MM/yyyy"
        historicos = tarefa.historico!
        carregarDadosLabel()
    }
    
    func carregarDadosLabel(){
        tituloLabel.text = tarefa.titulo
        pontosLabel.text = "\(tarefa.pontos.description) Pontos"
        dataFimLabel.text = formatData.string(from: tarefa.dataFim)
        if let id = tarefa.meta?.id {
            MetaDao.getMeta(for: id, completion: { (meta) in
                self.tituloMetaLabel.text = meta?.titulo
            })
        }
    }
}

extension DetalhesTarefaViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return historicos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let historico = historicos[indexPath.row]
        let dataTexto = formatData.string(from: historico.dataExecucao)
      
        cell.textLabel?.text = "\(dataTexto)"
        cell.selectionStyle = .none
        
        switch historico.status {
        case StatusTarefa.validacao.rawValue.uppercased():
            cell.detailTextLabel?.textColor = .orange
            cell.selectionStyle = .default
            cell.detailTextLabel?.text = "Para Aprovação"
        
        case StatusTarefa.pendente.rawValue.uppercased():
            cell.detailTextLabel?.textColor = .blue
            cell.detailTextLabel?.text = "Em Progresso"
        
        case StatusTarefa.aprovado.rawValue.uppercased():
            cell.detailTextLabel?.textColor = .green
            cell.detailTextLabel?.text = "Concluída"
        
        case StatusTarefa.reprovado.rawValue.uppercased():
            cell.detailTextLabel?.textColor = .red
            cell.detailTextLabel?.text = "Reprovada"
        
        case StatusTarefa.refazer.rawValue.uppercased():
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
            cell.detailTextLabel?.text = "Refazer"
            
        default:
            cell.detailTextLabel?.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            cell.detailTextLabel?.text = "Expirada"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ConclusaoTarefaViewController()
        vc.tarefa = tarefa!
        vc.historicoSelecionado = historicos[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
