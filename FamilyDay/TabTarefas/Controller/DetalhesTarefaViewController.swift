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
    @IBOutlet weak var statusLabel: UILabel!
    
    var tarefa: Tarefa?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
