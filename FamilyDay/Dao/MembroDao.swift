//
//  File.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 06/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import Foundation
import Alamofire

class MembroDao {
    
    static func cadastrarMembro(usuario: Usuario, idFamilia: String, completion: @escaping(String?) -> Void){
        
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let stringData = fullISO8610Formatter.string(from: usuario.dataNascimento!)
        
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token]
        
        let parametros = ["nome": usuario.nome, "dataNascimento": stringData, "telefone": usuario.telefone, "tipo": usuario.tipo, "genero": usuario.genero, "email": usuario.email, "familia": idFamilia]
        
        AF.request("\(Configuration.URL_API)/usuarios/cadastrar-membro-familia", method: .post, parameters: parametros, headers: header).responseJSON { (retorno) in
            print(retorno.result)
            switch retorno.result {

            case .success(let body):
                print(body)
                let tokenUsuario = (body as! [String: String])["token"] as? String
                completion(tokenUsuario)
                break
            case .failure(_):
                completion(nil)
            }
        }
    }
}
