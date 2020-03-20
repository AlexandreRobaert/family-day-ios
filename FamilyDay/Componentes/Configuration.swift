//
//  Configuration.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 28/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import Foundation

enum UserDefaultsKeys: String {
    case token = "token"
    case primeiraVez = "primeiraVez"
    case idFamilia = "idFamilia"
    case idUsuario = "idUsuario"
}

class Configuration {
    
    static let URL_API: String = "https://api-family-day.herokuapp.com/api"
    
    let defaults = UserDefaults.standard
    static var shared: Configuration = Configuration()
    
    var token: String? {
        get {
            return defaults.string(forKey: UserDefaultsKeys.token.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.token.rawValue)
        }
    }
    
    var idFamilia: String? {
        get {
            return defaults.string(forKey: UserDefaultsKeys.idFamilia.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.idFamilia.rawValue)
        }
    }
    
    var idUsuario: String? {
        get {
            return defaults.string(forKey: UserDefaultsKeys.idUsuario.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.idUsuario.rawValue)
        }
    }
    
    private init() {
    }
}
