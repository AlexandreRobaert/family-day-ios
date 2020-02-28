//
//  Usuario.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 18/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class Usuario: NSObject {
    
    let idUsuario: Int?
    let nome: String
    let telefone: String?
    let email: String?
    let dataNascimento: Date
    let login: String
    let senha: String
    let ativo: Bool
    let responsavel: Bool
    
    init(idUsuario: Int?, nome: String, telefone: String?, email: String?, dataNascimento: Date, login: String, senha: String, ativo: Bool, responsavel: Bool) {
        
        self.idUsuario = idUsuario
        self.nome = nome
        self.telefone = telefone
        self.email = email
        self.dataNascimento = dataNascimento
        self.login = login
        self.senha = senha
        self.ativo = ativo
        self.responsavel = responsavel
    }
}
