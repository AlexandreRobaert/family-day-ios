//
//  MembrosViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 11/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class MembrosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var usuarios: [Usuario] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        UsuarioDao.getAllUsersFamily { (usuarios) in
            if let usuarios = usuarios {
                self.usuarios = usuarios
                self.tableView.reloadData()
                self.indicator.isHidden = true
            }
        }
    }
    
    @IBAction func telaNovoMembro(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(CadastroMembroViewController(), animated: true)
    }
}

extension MembrosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        usuarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMembro") as! MembroTableViewCell
        cell.configuraCelula(user: usuarios[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
}

extension MembrosViewController: ListaUsuarioDelegate {
    
    func adicionarUsuarioNaLista(user: Usuario) {
        usuarios.append(user)
        tableView.reloadData()
    }
    
    func carregarListaUsuario(users: [Usuario]) {
        // Não preciso implementar aqui
    }
}