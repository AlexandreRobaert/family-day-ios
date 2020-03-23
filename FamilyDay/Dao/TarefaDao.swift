
import Foundation
import Alamofire

class TarefaDao {
    
    static func cadastrarTarefa(tarefa: Tarefa, meta: Meta, usuarios: [Usuario], completion: @escaping(Bool) -> Void) {
        
        var membros: [String] = []
        for user in usuarios {
            membros.append(user.id!)
        }
        let formatData = DateFormatter()
        formatData.dateFormat = "yyyy/MM/dd"
        
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        let parametros: [String: Any] = ["titulo": tarefa.titulo, "descricao": tarefa.descricao, "dataInicio": formatData.string(from: tarefa.dataInicio),
                          "dataFim": formatData.string(from: tarefa.dataFim), "diariamente": tarefa.diariamente,
                          "personalizado": tarefa.personalizado, "pontos": tarefa.pontos,
                          "exigeComprovacao": tarefa.exigeComprovacao, "membros": membros, "meta": meta.id!]
        
        AF.request("\(Configuration.URL_API)/tarefas", method: .post, parameters: parametros, headers: header).responseJSON { (response) in
            print(response.result)
            if response.response?.statusCode == 201 {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
}
