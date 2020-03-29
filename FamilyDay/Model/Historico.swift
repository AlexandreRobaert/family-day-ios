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
    let status: String
    let membro: Usuario
    let pontosGanhos: Int
    let fotos: [String]
}
