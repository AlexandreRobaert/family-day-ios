//
//  Tarefa.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 19/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

struct Tarefa: Codable {
    
    var id: String
    var titulo: String
    var descricao: String
    var dataInicio: Date
    var dataFim: Date
    var personalizado: [String]
    var diariamente: Bool
    var pontos: Int
    var exigeComprovacao: Bool
}
