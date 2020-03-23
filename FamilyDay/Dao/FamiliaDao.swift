
import Foundation
import Alamofire

class FamiliaDao {
    
    
    static func cadastrarFamilia(nomeFamilia: String, idUsuario: String, completion: @escaping(Bool)->Void) {
        
        let parametros = ["nome": nomeFamilia, "dono": idUsuario]
        AF.request("\(Configuration.URL_API)/familias", method: .post, parameters: parametros).responseJSON { (response) in
            print(response.result)
            switch response.result {
                case .success(let body as [String: Any]):
                    let id = (body["retorno"] as! [String: String])["idFamilia"]
                    let token = (body["retorno"] as! [String: String])["token"]
                    Configuration.shared.idFamilia = id
                    Configuration.shared.token = token
                    completion(true)
                    break
                case .failure(let error):
                    print(error)
                    completion(false)
                case .success(_):
                    completion(false)
                
            }
        }
    }
}
