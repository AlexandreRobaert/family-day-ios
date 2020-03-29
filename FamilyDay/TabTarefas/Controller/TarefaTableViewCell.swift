//
//  TarefaTableViewCell.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 11/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class TarefaTableViewCell: UITableViewCell {

    @IBOutlet weak var tituloTarefaLabel: UILabel!
    @IBOutlet weak var usuarioDaTarefaLabel: UILabel!
    @IBOutlet weak var pontosLabel: UILabel!
    @IBOutlet weak var dataFimLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configuraCell(tarefa: Tarefa){
        
        let formatData = DateFormatter()
        formatData.dateFormat = "dd/MM/yyyy"
        
        tituloTarefaLabel.text = tarefa.titulo
        pontosLabel.text = tarefa.pontos > 1 ? "\(tarefa.pontos) Pontos" : "\(tarefa.pontos) Ponto"
        dataFimLabel.text = formatData.string(from: tarefa.dataFim)
    }
}
