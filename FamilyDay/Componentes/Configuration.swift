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
}

class Configuration {
    
    static let URL_API: String = "https://api-family-day.herokuapp.com/api/"
    
    let defaults = UserDefaults.standard
    static var shared: Configuration = Configuration()
    
    var token: String {
        get {
            return defaults.string(forKey: UserDefaultsKeys.token.rawValue)!
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.token.rawValue)
        }
    }
    
    var jaIniciouTutorial: Bool {
        get {
            return defaults.bool(forKey: UserDefaultsKeys.primeiraVez.rawValue)
        }
        set {
            defaults.set(newValue, forKey: UserDefaultsKeys.primeiraVez.rawValue)
        }
    }
    
    private init() {
        print("Já acessou Tutorial: \(self.jaIniciouTutorial)")
    }
}
