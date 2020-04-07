//
//  TabMetasViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 09/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class TabMetasViewController: UIViewController {
    
    var metas: [Meta] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let responsavel = Configuration.shared.usuarioResponsavel else { return }
        
        if responsavel {
            print(responsavel)
            navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showCadastrarMeta)), animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MetaDao.getMetasDaFamilia { (metas) in
            if let arrayMetas = metas {
                self.metas = arrayMetas
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func showCadastrarMeta() {
        navigationController?.pushViewController(CadastroMetaViewController(), animated: true)
    }
}

extension TabMetasViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return metas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "metaViewCell") as! MetaTableViewCell
        
        let meta = metas[indexPath.row]
        cell.configuraCelula(meta)
        cell.progressoMeta.progress = Float(meta.pontosAlvo) / Float(30000)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let telaMeta = CadastroMetaViewController()
        telaMeta.meta = metas[indexPath.row]
        navigationController?.pushViewController(telaMeta, animated: true)
    }
    
}

extension TabMetasViewController: TabelaMetasDelegate {
    func atualizarTabelaDeMetas(meta: Meta) {
        metas.append(meta)
        tableView.reloadData()
    }
}
