
import Foundation
import Alamofire
import SwiftyJSON
import Firebase

enum RedesSociais {
    case Facebook
    case Google
    case Apple
}

class UsuarioDao {
    
    class func getTokeApp(){
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Erro no TokenID do App: \(error)")
            } else if let result = result {
                Configuration.shared.deviceId = result.token
            }
        }
    }
    
    class func getUserfor(token: String, completion: @escaping (Usuario?) -> Void) -> Void {
        let headers: HTTPHeaders = ["x-access-token": token]
        
        AF.request("\(Configuration.URL_API)/usuarios/me", headers: headers).validate().responseDecodable(of: Usuario.self) {(response) in
            print(response.result)
            switch response.result {
            case .success(let usuario):
                Configuration.shared.idFamilia = usuario.idFamilia
                Configuration.shared.idUsuario = usuario.id
                Configuration.shared.usuarioResponsavel = usuario.tipo == "RESPONSAVEL" ? true : false
                completion(usuario)
            case .failure(_):
                completion(nil)
                print("Error ao buscar usuário")
            }
        }
    }
    
    class func getUserfor(id: String, completion: @escaping (Usuario?) -> Void) -> Void {
        let headers: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        
        AF.request("\(Configuration.URL_API)/usuarios/get/\(id)", headers: headers).validate().responseDecodable(of: Usuario.self) {(response) in
            switch response.result {
            case .success(let usuario):
                completion(usuario)
            case .failure(_):
                completion(nil)
                print("Error ao buscar usuário")
            }
        }
    }
    
    class func getAllUsersFamily(completion: @escaping ([Usuario]?) -> Void) -> Void {
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        var users: [Usuario] = []
        
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        AF.request("\(Configuration.URL_API)/familias/listar-membros", headers: header).validate().responseData { (data) in
            do {
                let json = try JSON(data: data.data!)
                
                for item in json.arrayValue {
                    
                    guard let dataNascimento = fullISO8610Formatter.date(from: item["dataNascimento"].stringValue) else {return}
                    
                    var genero: String = ""
                    
                    switch item["genero"].stringValue {
                    case "M":
                        genero = "MASCULINO"
                    case "F":
                        genero = "FEMININO"
                    default:
                        genero = "OUTROS"
                    }
                    
                    let user = Usuario(id: item["_id"].stringValue, nome: item["nome"].stringValue, dataNascimento: dataNascimento, tipo: item["tipo"].stringValue, email: item["email"].stringValue, genero: genero, senha: "", idFamilia: Configuration.shared.idFamilia!, ativo: item["ativo"].boolValue)
                    users.append(user)
                }
                completion(users)
                
            }catch {
                completion(nil)
                print(error)
            }
        }
    }
    
    class func getToken(login: String, senha: String, completion: @escaping (String?) -> Void) {
        
        let headers: HTTPHeaders = [.authorization(username: login, password: senha)]
        UsuarioDao.getTokeApp()
        let parametros = ["os": "IOS", "deviceId": Configuration.shared.deviceId]

        AF.request("\(Configuration.URL_API)/login", method: .post, parameters: parametros, headers: headers).responseJSON { (response) in
            switch response.result {
            case .success(let value as [String: Any]):
                if let token = value["token"] as? String {
                    Configuration.shared.token = token
                    completion(token)
                }else{
                    completion(nil)
                }
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
    
    class func getToken(tokenSocial: String, completion: @escaping (String?) -> Void) {
        
        
        let parametros = ["idToken": tokenSocial]

        AF.request("\(Configuration.URL_API)/login/login-google", method: .post, parameters: parametros).responseJSON { (response) in
            switch response.result {
            case .success(let value as [String: String]):
                if let token = value["token"] {
                    Configuration.shared.token = token
                    completion(token)
                }else{
                    completion(nil)
                }
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
    
    class func enviarEmailRecuperarSenha(emailNick: String, completion: @escaping (String?, String?)-> Void){
        
        let params = ["emailOuNick": emailNick]
        AF.request("\(Configuration.URL_API)/login/recuperar-senha", method: .post, parameters: params).responseJSON { (data) in
        
            switch data.result {
            case .success(let value):
               if let json = value as? Dictionary<String, Any> {
                if data.response?.statusCode == 200 {
                    let retorno = json["retorno"] as! Dictionary<String, String>
                    completion(retorno["email"]!, nil)
                }else{
                    let mensagem = json["mensagem"] as! String
                    completion(nil, mensagem)
                }
                }
            case .failure(let error):
                print(error.errorDescription!)
                completion(nil, "Falha")
            }
        }
    }
    
    class func validarCodigoRecuperacao(emailNick: String, codigo: String, completion: @escaping (Bool)-> Void){
        
        let params = ["emailOuNick": emailNick, "codigo": codigo]
        
        AF.request("\(Configuration.URL_API)/login/validar-codigo", method: .post, parameters: params).validate().responseJSON { (data) in
            print(data.result)
            switch (data.response?.statusCode) {
            case 200:
                completion(true)
            case 203:
                completion(false)
            case .none:
                completion(false)
            case .some(_):
                completion(false)
            }
            
        }
    }
    
    class func getTokenMembroFor(id from: String, completion: @escaping (String?) -> Void){
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        
        AF.request("\(Configuration.URL_API)/usuarios/gerar-token-membro/\(from)", headers: header).responseJSON { (retorno) in
            
            switch retorno.result {
            case .success(let value):
                if retorno.response?.statusCode == 200 {
                    let json = JSON(value)
                    let retorno = json["retorno"].dictionaryObject as! Dictionary<String, String>
                    completion(retorno["token"]!)
                }
            case .failure(_):
                print("Falha")
            }
        }
    }
    
    class func cadastrarUsuario(_ usuario: Usuario, deviceID: String, completion: @escaping (String?, _ erroMensagem: String?) -> Void){
        
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let stringData = fullISO8610Formatter.string(from: usuario.dataNascimento!)
        
        let parametros = ["nome": usuario.nome, "dataNascimento": stringData, "tipo": usuario.tipo, "genero": usuario.genero, "email": usuario.email, "senha": usuario.senha, "os": "IOS", "deviceId": deviceID, "telefone": "x"]
        
        AF.request("\(Configuration.URL_API)/usuarios", method: .post, parameters: parametros).responseJSON { (response) in
            print(response.result)
            switch response.result {
            case .success(let result as [String: Any]):
                switch response.response?.statusCode {
                case 201:
                    if let idUser = result["id"] as? String {
                        Configuration.shared.idUsuario = idUser
                        completion(idUser, nil)
                    }
                default:
                    if let msg = result["mensagem"] as? String {
                        print(msg)
                        completion(nil, msg)
                    }
                }
            case .success(_):
                print("Sucesso na conexão")
                completion(nil, nil)
            case .failure(let error):
                completion(nil, nil)
                print(error)
            }
        }
    }
    
    class func atualizarUsuario(_ usuario: Usuario, deviceID: String, completion: @escaping (String?, _ erroMensagem: String?) -> Void){
        
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let stringData = fullISO8610Formatter.string(from: usuario.dataNascimento!)
        
        let parametros: [String: Any] = ["nome": usuario.nome, "nickName": usuario.apelido!, "dataNascimento": stringData, "tipo": usuario.tipo! as Any, "genero": usuario.genero, "email": usuario.email, "senha": usuario.senha, "os": "IOS", "deviceId": deviceID, "ativo": usuario.ativo]
        
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        
        AF.request("\(Configuration.URL_API)/usuarios/\(usuario.id!)", method: .put, parameters: parametros, headers: header).responseJSON { (response) in
            
            print(response.result)
            
            switch response.result {
            case .success(let result as [String: Any]):
                switch response.response?.statusCode {
                case 200:
                    Configuration.shared.idUsuario = usuario.id!
                    completion(usuario.id!, nil)
                default:
                    if let msg = result["mensagem"] as? String {
                        print(msg)
                        completion(nil, msg)
                    }
                }
            case .success(_):
                print("Sucesso na conexão")
                completion(nil, nil)
            case .failure(let error):
                completion(nil, nil)
                print(error)
            }
        }
    }
    
    class func atualizarSenha(emailOuNick: String, codigo: String, senha: String, completion: @escaping (Bool) -> Void){
        
        let parametros: [String: String] = ["emailOuNick": emailOuNick, "codigo": codigo, "senha": senha]
        
        AF.request("\(Configuration.URL_API)/login/alterar-senha", method: .put, parameters: parametros).responseJSON { (data) in
            switch data.result {
            case .success(_):
                switch data.response?.statusCode {
                case 200:
                    completion(true)
                case 203:
                    completion(false)
                default:
                    completion(false)
                }
            case .failure(_):
                completion(false)
            }
        }
    }
    
    static func cadastrarMembro(usuario: Usuario, idFamilia: String, completion: @escaping(Bool) -> Void){
        
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let stringData = fullISO8610Formatter.string(from: usuario.dataNascimento!)
        
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        
        let parametros = ["nome": usuario.nome, "dataNascimento": stringData, "tipo": usuario.tipo, "genero": usuario.genero, "email": usuario.email, "familia": idFamilia, "telefone": " "]
        
        AF.request("\(Configuration.URL_API)/usuarios/cadastrar-membro-familia", method: .post, parameters: parametros, headers: header).responseJSON { (retorno) in
            switch retorno.result {
            case .success(let body):
                print(body)
                completion(true)
                break
            case .failure(_):
                completion(false)
            }
        }
    }
}
