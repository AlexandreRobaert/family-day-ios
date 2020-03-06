//
//  UsuarioDao.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 01/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import Foundation
import Alamofire

class UsuarioDao {
    
    class func getUserfor(token: String, completion: @escaping (Usuario?) -> Void) -> Void {
        let headers: HTTPHeaders = ["x-access-token": token]
        
        AF.request("\(Configuration.URL_API)/usuarios/me", headers: headers).validate().responseDecodable(of: Usuario.self) {(response) in
            switch response.result {
            case .success(let usuario):
                completion(usuario)
            case .failure(_):
                print("Error ao buscar usuário")
            }
        }
    }
    
    class func getToken(login: String, senha: String, completion: @escaping (String?) -> Void){
        
        let headers: HTTPHeaders = [.authorization(username: login, password: senha)]

        AF.request("\(Configuration.URL_API)/login", method: .post, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value as [String: Any]):
                completion(value["token"] as? String)
                break
            case .success(_):
                print("Sucesso sem usuário")
                completion(nil)
            case .failure(_):
                print("Falha!")
                completion(nil)
            }
        }
    }
    
    class func cadastrarUsuario(_ usuario: Usuario, deviceID: String, completion: @escaping (Usuario?, _ arrayDeErros: Array<String>?) -> Void){
        let headers: HTTPHeaders = ["x-access-token": Configuration.shared.token]
        
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let stringData = fullISO8610Formatter.string(from: usuario.dataNascimento!)
        
        let parametros = ["nome": usuario.nome, "dataNascimento": stringData, "telefone": usuario.telefone, "tipo": usuario.tipo, "genero": usuario.genero, "email": usuario.email, "senha": usuario.senha, "os": "IOS", "deviceId": deviceID]
        
        AF.request("\(Configuration.URL_API)/usuarios", method: .post, parameters: parametros, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let result as [String: Any]):
                switch response.response?.statusCode {
                case 201:
                    if let token = result["token"] as? String{
                        Configuration.shared.token = token
                        var user = usuario
                        user.id = (result["id"] as! String)
                        completion(user, nil)
                    }
                default:
                    if let mensagens = result["motivo"] as? Array<String> {
                        for msg in mensagens {
                            print(msg)
                        }
                        completion(nil, mensagens)
                    }
                }
            case .success(_):
                print("Sucesso na conexão")
            case .failure(let error):
                print(error)
            }
        }
    }
}
