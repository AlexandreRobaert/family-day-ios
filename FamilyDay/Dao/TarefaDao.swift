
import Foundation
import Alamofire
import SwiftyJSON

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
            if response.response?.statusCode == 201 {
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    static func getTodasTarefasDaFamilia(entre: Date, ate: Date, completion: @escaping ([Tarefa]) -> Void){
        
        let formatData = DateFormatter()
        formatData.dateFormat = "yyyy-MM-dd"
        
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let stringDataInicio = formatData.string(from: entre)
        let stringDataFim = formatData.string(from: ate)
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        let URL = "\(Configuration.URL_API)/tarefas/listar-tarefas-familia/\(stringDataInicio)/\(stringDataFim)"
        
        AF.request(URL, headers: header).responseJSON { (response) in
            var tarefas: [Tarefa] = []
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for item in json.arrayValue {
                    
                    let dataInicio = fullISO8610Formatter.date(from: item["dataInicio"].stringValue)!
                    let dataFim = fullISO8610Formatter.date(from: item["dataFim"].stringValue)!
                    let diasDaSemana = item["personalizado"].arrayObject as! Array<Int>
                    let idDosUsuarios = item["membros"].arrayObject as! Array<String>
                    
                    var usuarios: [Usuario] = []
                    for id in idDosUsuarios {
                        let usuario = Usuario(id: id, nome: "", dataNascimento: Date(), telefone: "", tipo: "", email: "", genero: "", senha: "", idFamilia: "", ativo: true)
                        usuarios.append(usuario)
                    }
                    
                    let meta = Meta(id: item["meta"].stringValue, titulo: "", descricao: "", pontosAlvo: 0)
                    
                    let tarefa = Tarefa(id: item["id"].stringValue, titulo: item["titulo"].stringValue, descricao: item["descricao"].stringValue, dataInicio: dataInicio, dataFim: dataFim, personalizado: diasDaSemana, diariamente: item["diariamente"].boolValue, pontos: item["pontos"].intValue, exigeComprovacao: item["exigeComprovacao"].boolValue, usuarios: usuarios, meta: meta)
                    
                    tarefas.append(tarefa)
                }
                
                completion(tarefas)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
