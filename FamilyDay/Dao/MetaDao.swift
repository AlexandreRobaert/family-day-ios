//
//  Meta.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 09/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import Foundation
import Alamofire

class MetaDao {
    
    static func cadastrarMeta(meta: Meta, idFamilia: String, completion: @escaping(String?) -> Void) {
        
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token]
        let parametros = ["titulo": "PS4", "descricao": "Seja um bom filho e será recompensado", "pontosAlvo": "500", "familia": idFamilia]
        
        AF.request("\(Configuration.URL_API)/metas", method: .post, parameters: parametros, headers: header).responseJSON { (response) in
            print(response.result)
            switch response.response?.statusCode {
            case 201:
                print("cadastrou")
            case .none:
                completion(nil)
            case .some(_):
                completion(nil)
            }
        }
    }
}
