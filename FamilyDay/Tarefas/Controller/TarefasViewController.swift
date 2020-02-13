//
//  TarefasViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 07/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class TarefasViewController: UIViewController {

    @IBOutlet weak var switchTarefas: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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

extension TarefasViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTarefas", for: indexPath) as! TarefaTableViewCell
        
        cell.tituloTarefa.text = "Titulo Novo"
        
        return cell
    }
    
    // MARK: - TableViewDelete
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(DetalhesTarefaViewController(), animated: true, completion: nil)
    }
}
