//
//  DiasDaSemanaTableViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 19/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

protocol ListaDiasDelegate {
    func carregarListaDiasDaSemana(dias: [String])
}

class DiasDaSemanaTableViewController: UITableViewController {
    
    let diasDaSemana = ["SEGUNDA", "TERCA", "QUARTA", "QUINTA", "SEXTA", "SABADO", "DOMINGO"]
    
    var diasSelecionados: [String] = []
    var delegate: ListaDiasDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "celula")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        delegate?.carregarListaDiasDaSemana(dias: diasSelecionados)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diasDaSemana.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let dia = diasDaSemana[indexPath.row]
        cell.textLabel?.text = indexPath.row < 5 ? "Toda \(dia.lowercased())-feira" : "Todo \(dia.lowercased())"
        
        if diasSelecionados.contains(dia){
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            diasSelecionados.append(diasDaSemana[indexPath.row])
        }else{
            cell.accessoryType = .none
            if let position = diasSelecionados.firstIndex(of: diasDaSemana[indexPath.row]){
                diasSelecionados.remove(at: position)
            }
        }
    }
}
