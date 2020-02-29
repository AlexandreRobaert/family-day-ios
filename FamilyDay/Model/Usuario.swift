//
//  Usuario.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 18/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//
import Foundation

struct Usuario: Codable {
    var id: String?
    let nome: String
    let dataNascimento: Date?
    let telefone: String
    let tipo: String?
    let email: String
    let genero: String
    let senha: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case nome = "nome"
        case dataNascimento = "dataNascimento"
        case telefone = "telefone"
        case tipo = "tipo"
        case email = "email"
        case genero = "genero"
        case senha = "senha"
    }
    
    init(id: String, nome: String, dataNascimento: Date, telefone: String, tipo: String, email: String, genero: String, senha: String) {
        self.id = id
        self.nome = nome
        self.dataNascimento = dataNascimento
        self.telefone = telefone
        self.tipo = tipo
        self.email = email
        self.genero = genero
        self.senha = senha
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        nome = try container.decode(String.self, forKey: .nome)
        
        let dataString = try container.decode(String.self, forKey: .dataNascimento)
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dataNascimento = fullISO8610Formatter.date(from: dataString)!
        
        telefone = try container.decode(String.self, forKey: .telefone)
        tipo = try container.decode(String.self, forKey: .tipo)
        email = try container.decode(String.self, forKey: .email)
        genero = try container.decode(String.self, forKey: .genero)
        senha = ""
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(nome, forKey: .nome)
        
        let codificador = JSONEncoder()
        codificador.dateEncodingStrategy = .iso8601
        let data = try codificador.encode(dataNascimento)
        try container.encode(data, forKey: .dataNascimento)
        try container.encode(telefone, forKey: .telefone)
        try container.encode(tipo, forKey: .tipo)
        try container.encode(email, forKey: .email)
        try container.encode(genero, forKey: .genero)
        try container.encode(senha, forKey: CodingKeys.senha)
    }
}
