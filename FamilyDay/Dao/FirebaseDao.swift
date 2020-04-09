//
//  FirebaseDao.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 08/04/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseDao {
    
    class func uploadImagens(idTarefa: String, numeroDaFoto: Int, imagem: UIImage,
                             progress: @escaping(Double) -> Void, completion: @escaping(String?) -> Void){
        
        let idFamilia = Configuration.shared.idFamilia!
        let data = imagem.jpegData(compressionQuality: 30)!
        let refImage = Storage.storage().reference().child("\(idFamilia)/tarefas/\(idTarefa)/imagens/\(numeroDaFoto).jpg")
        
        let uploadTask = refImage.putData(data)
        
        uploadTask.observe(.progress) { (snapshot) in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
            / Double(snapshot.progress!.totalUnitCount)
            progress(percentComplete)
        }
        
        uploadTask.observe(.success) { (snapshot) in
            completion(refImage.fullPath)
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            
            if let error = snapshot.error as NSError? {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    break
                case .unauthorized:
                    print("Usuário não autorizado")
                    break
                default:
                    print("Algum Erro")
                }
                
                completion(nil)
            }
        }
    }
}
