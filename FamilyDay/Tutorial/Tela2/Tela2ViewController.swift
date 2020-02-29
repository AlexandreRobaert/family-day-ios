//
//  Tela2ViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 27/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class Tela2ViewController: UIViewController {

    @IBOutlet weak var labelDescricao: UILabel!
    var nomeGrupo: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let grupo = nomeGrupo {
            labelDescricao.text = "Nome do grupo \(grupo) passado por parâmetro"
        }
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
