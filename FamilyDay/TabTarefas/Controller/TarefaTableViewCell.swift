//
//  TarefaTableViewCell.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 11/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class TarefaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tituloTarefa: UILabel!
    @IBOutlet weak var nomeMembro: UILabel!
    @IBOutlet weak var pontosTarefa: UILabel!
    @IBOutlet weak var dataProximaTarefa: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configuraCell(tarefa: Tarefa){
        
        let formatData = DateFormatter()
        formatData.dateFormat = "dd/MM/yyyy"
        
        var historico:Historico!
        var countHistorico = 0
        
        for itemHistorico in tarefa.historico! {
            if itemHistorico.status == StatusTarefa.pendente.rawValue {
                historico = itemHistorico
                break
            }
        }
    
        for itemHis in tarefa.historico! {
            countHistorico += itemHis.status != StatusTarefa.aprovado.rawValue && itemHis.status != StatusTarefa.expirado.rawValue ? 1 : 0
        }
        
        let vezesTarefa = countHistorico > 1 ? "\(countHistorico) Vezes" : "\(countHistorico) Vez"
        tituloTarefa.text = "\(tarefa.titulo)  - \(vezesTarefa)"
        pontosTarefa.text = tarefa.pontos > 1 ? "\(tarefa.pontos) Pontos" : "\(tarefa.pontos) Ponto"
        dataProximaTarefa.text = historico != nil ? formatData.string(from: historico.dataExecucao) : "Nenhuma"
    }
}
