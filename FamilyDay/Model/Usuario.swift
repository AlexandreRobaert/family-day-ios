//
//  Usuario.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 18/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//
import Foundation

struct Usuario: Codable, Equatable {
    var id: String?
    var nome: String
    var dataNascimento: Date?
    let tipo: String?
    var email: String
    var genero: String
    var senha: String
    let idFamilia: String
    var ativo: Bool

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nome = "nome"
        case dataNascimento = "dataNascimento"
        case telefone = "telefone"
        case tipo = "tipo"
        case email = "email"
        case genero = "genero"
        case senha = "senha"
        case idFamilia = "familia"
        case ativo = "ativo"
    }
    
    init(id: String, nome: String, dataNascimento: Date, tipo: String, email: String, genero: String, senha: String, idFamilia: String, ativo: Bool) {
        self.id = id
        self.nome = nome
        self.dataNascimento = dataNascimento
        self.tipo = tipo
        self.email = email
        self.genero = genero
        self.senha = senha
        self.idFamilia = idFamilia
        self.ativo = ativo
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        nome = try container.decode(String.self, forKey: .nome)
        
        let dataString = try container.decode(String.self, forKey: .dataNascimento)
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dataNascimento = fullISO8610Formatter.date(from: dataString)!
        
        tipo = try container.decode(String.self, forKey: .tipo)
        email = try container.decode(String.self, forKey: .email)
        genero = try container.decode(String.self, forKey: .genero)
        senha = ""
        idFamilia = try container.decode(String.self, forKey: .idFamilia)
        ativo = try container.decode(Bool.self, forKey: .ativo)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nome, forKey: .nome)
        
        let codificador = JSONEncoder()
        codificador.dateEncodingStrategy = .iso8601
        let data = try codificador.encode(dataNascimento)
        try container.encode(data, forKey: .dataNascimento)
        try container.encode(tipo, forKey: .tipo)
        try container.encode(email, forKey: .email)
        try container.encode(genero, forKey: .genero)
        try container.encode(senha, forKey: .senha)
        try container.encode(ativo, forKey: .ativo)
    }
}
