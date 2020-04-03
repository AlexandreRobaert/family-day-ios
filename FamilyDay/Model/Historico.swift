//
//  Historico.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 24/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

struct Historico: Codable {

    let id: String
    let dataExecucao: Date
    var status: String
    let idMembro: String
    let pontos: Int
    let fotos: [String]
    var comentario: String
}
