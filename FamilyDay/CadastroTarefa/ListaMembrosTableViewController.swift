//
//  ListaMembrosTableViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 19/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

protocol ListaUsuarioDelegate {
    
    func carregarListaUsuario(users: [Usuario])
    func adicionarUsuarioNaLista(user: Usuario)
}

class ListaMembrosTableViewController: UITableViewController {
    
    var usuarios: [Usuario] = []
    var usuariosSelecionados: [Usuario] = []
    var delegate: ListaUsuarioDelegate!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellUsuario")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        delegate.carregarListaUsuario(users: usuariosSelecionados)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usuarios.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellUsuario", for: indexPath)
        
        let usuario = usuarios[indexPath.row]
        
        if usuario.id! != Configuration.shared.idUsuario! {
            cell.textLabel?.text = usuario.nome
        }else{
            cell.textLabel?.text = usuario.nome + " Você"
            cell.textLabel?.textColor = UIColor(named: "Roxo")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            usuariosSelecionados.append(usuarios[indexPath.row])
        } else {
            cell.accessoryType = .none
            if let position = usuariosSelecionados.firstIndex(of: usuarios[indexPath.row]){
                usuariosSelecionados.remove(at: position)
            }
        }
    }
}
