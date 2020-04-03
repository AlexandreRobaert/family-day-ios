
import Foundation
import Alamofire
import SwiftyJSON

class MetaDao {
    
    static func cadastrarMeta(meta: Meta, completion: @escaping(String?) -> Void) {
        
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        let parametros = ["titulo": meta.titulo, "descricao": meta.descricao, "pontosAlvo": String(meta.pontosAlvo), "familia": Configuration.shared.idFamilia!]
        
        AF.request("\(Configuration.URL_API)/metas", method: .post, parameters: parametros, headers: header).responseJSON { (response) in
            
            switch response.result {
                case .success(let value as [String: Any]):
                    if let retorno = value["retorno"] as? [String: String] {
                        let idMeta = retorno["metaId"]
                        completion(idMeta)
                    }else{
                        completion(nil)
                    }
                case .success(_):
                    completion(nil)
                case .failure(_):
                    completion(nil)
            }
        }
    }
    
    static func getMeta(for id: String, completion: @escaping(Meta?) -> Void){
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        AF.request("\(Configuration.URL_API)/metas/\(id)", headers: header).validate().responseData { (data) in
            do {
                let json = try JSON(data: data.data!)
                let meta = Meta(id: id, titulo: json["titulo"].stringValue, descricao: json["descricao"].stringValue, pontosAlvo: json["pontosAlvo"].intValue)
                completion(meta)
            }catch {
                completion(nil)
                print(error)
            }
        }
    }
    
    static func getMetasDaFamilia(completion: @escaping(Array<Meta>?)->Void){
        var metas: [Meta] = []
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        AF.request("\(Configuration.URL_API)/metas", headers: header).validate().responseData { (data) in
            do {
                let json = try JSON(data: data.data!)
                
                for item in json.arrayValue {
                    let meta = Meta(id: item["_id"].stringValue, titulo: item["titulo"].stringValue, descricao: item["descricao"].stringValue, pontosAlvo: item["pontosAlvo"].intValue)
                        metas.append(meta)
                }
                completion(metas)
                
            }catch {
                completion(nil)
                print(error)
            }
        }
    }
    
    static func atualizarMeta(meta: Meta, completion: @escaping(Bool) -> Void) {
        
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        let parametros = ["titulo": meta.titulo, "descricao": meta.descricao, "pontosAlvo": String(meta.pontosAlvo)]
        
        AF.request("\(Configuration.URL_API)/metas/\(meta.id!)", method: .put, parameters: parametros, headers: header).responseJSON { (response) in
            switch response.response?.statusCode {
            case 200:
                print("Atualizou")
                completion(true)
            case .none:
                completion(false)
            case .some(_):
                completion(false)
            }
        }
    }
    
}
