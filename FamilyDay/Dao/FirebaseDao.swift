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
    
    class func uploadImagens(idTarefa: String, numeroDaFoto: Int, imagem: UIImage, completion: @escaping(String?) -> Void){
        
        let idFamilia = Configuration.shared.idFamilia!
        let data = imagem.jpegData(compressionQuality: 0.2)!
        let refImage = Storage.storage().reference().child("\(idFamilia)/tarefas/\(idTarefa)/imagens/\(numeroDaFoto).jpg")
        
        let uploadTask = refImage.putData(data)
        
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
    
    class func downloadImagen(forUrl urlImagem: String, completion: @escaping(UIImage?) -> Void){
        
        let refImage = Storage.storage().reference().child(urlImagem)
        refImage.getData(maxSize: 10 * 1024 * 1024) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            }else{
                let image = UIImage(data: data!)
                completion(image)
            }
        }
    }
}
