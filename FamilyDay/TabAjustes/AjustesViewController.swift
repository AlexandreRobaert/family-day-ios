//
//  AjustesViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 10/03/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class AjustesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sairDoApp(_ sender: Any) {
        Configuration.shared.token = nil
        
        let navigation = navigationController?.storyboard?.instantiateViewController(identifier: "PrimeiroNavigationController")
        navigationController?.dismiss(animated: true, completion: nil)
        present(navigation!, animated: true, completion: nil)
    }
}
