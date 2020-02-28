//
//  Mensagem.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 18/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import Foundation
import MessageUI

class Mensagem: NSObject, MFMessageComposeViewControllerDelegate {
    
    // MARK: - Métodos
    func  configuraSMS(usuario: Usuario) -> MFMessageComposeViewController? {
        
        if MFMessageComposeViewController.canSendText() {
            let componenteMensagem = MFMessageComposeViewController()
            
            guard let telefone = usuario.telefone else {return componenteMensagem}
            componenteMensagem.recipients = [telefone]
            componenteMensagem.body = "Olá \(usuario.nome), baixe no App Family Day, seu filho já criou o grupo e precisa da sua permissão!"
            componenteMensagem.messageComposeDelegate = self
            
            return componenteMensagem
        }
    
        return nil
    }
    
    // MARK: - MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
