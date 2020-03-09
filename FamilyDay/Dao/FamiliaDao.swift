//
//  FamiliaDao.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 05/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import Foundation
import Alamofire

class FamiliaDao {
    
    
    static func cadastrarFamilia(nomeFamilia: String, completion: @escaping(String?)->Void){
        
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token]
        let parametros = ["nome": nomeFamilia]
        AF.request("\(Configuration.URL_API)/familias", method: .post, parameters: parametros, headers: header).responseJSON { (response) in
            print(response.result)
            switch response.result {
                case .success(let body as [String: Any]):
                    let id = (body["retorno"] as! [String: String])["idFamilia"]
                    Configuration.shared.idFamilia = id!
                    completion(id)
                    break
                case .failure(let error):
                    print(error)
                    completion(nil)
                case .success(_):
                    completion(nil)
                
            }
        }
    }
}
