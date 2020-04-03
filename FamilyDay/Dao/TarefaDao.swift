
import Foundation
import Alamofire
import SwiftyJSON

enum StatusTarefa: String {
    case pendente = "pendente"
    case validacao = "validacao"
    case aprovado = "aprovado"
    case reprovado = "reprovado"
    case expirado = "expirado"
    case refazer = "refazer"
    
}

class TarefaDao {
    
    static let URL_Tarefas = "\(Configuration.URL_API)/tarefas"
    
    static func cadastrarTarefa(tarefa: Tarefa, meta: Meta, usuarios: [Usuario], completion: @escaping(Bool) -> Void) {
        
        var membros: [String] = []
        for user in usuarios {
            membros.append(user.id!)
        }
        let formatData = DateFormatter()
        formatData.dateFormat = "yyyy/MM/dd"
        
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.timeZone = .current
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        let parametros: [String: Any] = ["titulo": tarefa.titulo, "descricao": tarefa.descricao, "dataInicio": fullISO8610Formatter.string(from: tarefa.dataInicio),
                          "dataFim": fullISO8610Formatter.string(from: tarefa.dataFim), "diariamente": tarefa.diariamente,
                          "personalizado": tarefa.personalizado, "pontos": tarefa.pontos,
                          "exigeComprovacao": tarefa.exigeComprovacao, "membros": membros, "meta": meta.id!]
        
        AF.request(URL_Tarefas, method: .post, parameters: parametros, headers: header).responseJSON { (response) in
            if response.response?.statusCode == 201 {
                completion(true)
            }else{
                completion(false)
                print(response.result)
            }
        }
    }
    
    static func getQuantidadesTarefas(dataInicio: Date, dataFim: Date, completion: @escaping ([String : Int]?) -> Void){
        
        var quantidades: [String : Int] = [:]
        
        let formatData = DateFormatter()
        formatData.dateFormat = "yyyy-MM-dd"
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        
        let stringDataInicio = formatData.string(from: dataInicio)
        let stringDataFim = formatData.string(from: dataFim)
        let URL = "\(URL_Tarefas)/listar-dashboard/\(stringDataInicio)/\(stringDataFim)"
        AF.request(URL, headers: header).validate().responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                quantidades["aprovado"] = json["aprovado"].intValue
                quantidades["expirado"] = json["expirado"].intValue
                quantidades["pendente"] = json["pendente"].intValue
                quantidades["refazer"] = json["refazer"].intValue
                quantidades["reprovado"] = json["reprovado"].intValue
                quantidades["validacao"] = json["validacao"].intValue
                quantidades["total"] = json["total"].intValue
                
            case .failure(let erro):
                print(erro)
                completion(nil)
            }
            completion(quantidades)
        }
    }
    
    static func getTarefas(usuarioEResponsavel: Bool, entre: Date, ate: Date, status: StatusTarefa?, completion: @escaping ([Tarefa]) -> Void){
        
        let formatData = DateFormatter()
        formatData.dateFormat = "yyyy-MM-dd"
        
        let fullISO8610Formatter = DateFormatter()
        fullISO8610Formatter.timeZone = .current
        fullISO8610Formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let endPoint = usuarioEResponsavel ? "/listar-tarefas-familia/" : "/listar-tarefas-membro/"
        let stringDataInicio = formatData.string(from: entre)
        let stringDataFim = formatData.string(from: ate)
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        
        var filtro = ""
        if let status = status?.rawValue {
            filtro = status
        }else{
            filtro = "null"
        }
        
        let URL = "\(URL_Tarefas)\(endPoint)\(stringDataInicio)/\(stringDataFim)/\(filtro)"
        print(URL)
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
                    let historico = item["historico"].arrayValue
                    
                    var historicos:[Historico] = []
                    for item in historico {
                        
                        let data = fullISO8610Formatter.date(from: item["dataExecucao"].stringValue)
                        let history = Historico(id: item["_id"].stringValue, dataExecucao: data!, status: item["status"].stringValue, idMembro: item["membro"].stringValue, pontos: item["pontos"].intValue, fotos: [], comentario: item["comentario"].stringValue)
                        historicos.append(history)
                    }
                    
                    var usuarios: [Usuario] = []
                    for id in idDosUsuarios {
                        let usuario = Usuario(id: id, nome: "", dataNascimento: Date(), telefone: "", tipo: "", email: "", genero: "", senha: "", idFamilia: "", ativo: true)
                        usuarios.append(usuario)
                    }
                    
                    let meta = Meta(id: item["meta"].stringValue, titulo: "", descricao: "", pontosAlvo: 0)
                    
                    let tarefa = Tarefa(id: item["id"].stringValue, titulo: item["titulo"].stringValue, descricao: item["descricao"].stringValue, dataInicio: dataInicio, dataFim: dataFim, personalizado: diasDaSemana, diariamente: item["diariamente"].boolValue, pontos: item["pontos"].intValue, exigeComprovacao: item["exigeComprovacao"].boolValue, usuarios: usuarios, meta: meta, historico: historicos)
                    
                    tarefas.append(tarefa)
                }
                
                completion(tarefas)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func atualizarTarefa(historico: Historico, idTarefa: String, completion: @escaping(Bool) -> Void){
    
        let header: HTTPHeaders = ["x-access-token": Configuration.shared.token!]
        let endPoint = Configuration.shared.usuarioResponsavel! ? "/responsavel-atualiza-status/\(idTarefa)" : "/membro-atualiza-status/\(idTarefa)"
        print("\(URL_Tarefas)\(endPoint)")
        let parametros = ["id": historico.id, "status": historico.status, "comentario": historico.comentario]
       
        AF.request("\(URL_Tarefas)\(endPoint)", method: .put, parameters: parametros, headers: header).responseJSON { (retorno) in
            print(retorno.result)
            switch retorno.result {
            case .success(_):
                completion(true)
                break
                
            case .failure(let error):
                completion(false)
                print(error)
            }
        }
    }
}
