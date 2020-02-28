//
//  MenuOpcoesEnvio.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 18/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

import UIKit

enum MenuOpcoes {
    case sms
    case whatsapp
}

class MenuDeOpcoesEnvio: NSObject {
    
    func configuraMenuOpcoes(completion: @escaping(_ opcao: MenuOpcoes) -> Void) -> UIAlertController {
        let alertController = UIAlertController(title: "Convidar Responsável", message: "Escolha uma das opções abaixo", preferredStyle: .alert)
        let sms = UIAlertAction(title: "Enviar SMS", style: .default) { (acao) in
            completion(.sms)
        }
        let whatsapp = UIAlertAction(title: "WhatsApp", style: .default) { (acao) in
            completion(.whatsapp)
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(whatsapp)
        alertController.addAction(sms)
        alertController.addAction(cancelar)
        
        return alertController
    }

}

