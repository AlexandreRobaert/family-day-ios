//
//  TarefasViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 07/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class TarefasViewController: UIViewController {

    @IBOutlet weak var switchTarefas: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var tarefas: [Tarefa] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        let dataInicio = Calendar.current.date(byAdding: .day, value: -10, to: Date())!
        
        TarefaDao.getTodasTarefasDaFamilia(entre: dataInicio, ate: Date(), completion: { (tarefas) in
            self.tarefas = tarefas
            self.tableView.reloadData()
        })
    }
    
    @IBAction func telaCadastrarTarefa(_ sender: Any) {
        navigationController?.pushViewController(CadastrarTarefaViewController(), animated: true)
    }
}

extension TarefasViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tarefas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTarefas", for: indexPath) as! TarefaTableViewCell
        
        cell.configuraCell(tarefa: tarefas[indexPath.row])
        
        return cell
    }
    
    // MARK: - TableViewDelete
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetalhesTarefaViewController()
        vc.tarefa = tarefas[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
