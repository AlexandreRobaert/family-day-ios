//
//  HomeViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 07/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var fotoPerfilImage: UIImageView!
    @IBOutlet weak var tipoPerfilLabel: UILabel!
    @IBOutlet weak var nomePerfilLabel: UILabel!
    @IBOutlet weak var pontuacaoPerfilLabel: UILabel!
    
    @IBOutlet weak var collectionMetas: UICollectionView!
    @IBOutlet weak var collectionTarefas: UICollectionView!
    
    let identifierMeta = "celulaMeta"
    let identifierTarefa = "celulaTarefa"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fotoPerfilImage.layer.cornerRadius = self.fotoPerfilImage.frame.width / 2
        self.fotoPerfilImage.layer.borderWidth = 1
        self.fotoPerfilImage.layer.masksToBounds = true
        self.fotoPerfilImage.layer.borderColor = UIColor.lightGray.cgColor
        
        collectionMetas.dataSource = self
        collectionMetas.delegate = self
        collectionTarefas.dataSource = self
        collectionMetas.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionTarefas {
            return 1
        } else {
            return 12
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.collectionMetas {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierMeta, for: indexPath) as! MetasCollectionViewCell
            cell.tituloMeta.text = "Meta Título"
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 12
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifierTarefa, for: indexPath) as! TarefasCollectionViewCell
            cell.tituloTarefa.text = "Título tarefa"
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 12
            return cell
        }
    }
}
