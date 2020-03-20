//
//  Meta.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 09/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import Foundation

struct Meta: Codable {
    
    var id: String?
    var titulo: String
    var descricao: String
    var pontosAlvo: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case titulo = "titulo"
        case descricao = "descricao"
        case pontosAlvo = "pontosAlvo"
    }
}
