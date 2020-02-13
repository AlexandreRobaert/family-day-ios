//
//  LoginViewController.swift
//  FamilyDay
//
//  Created by Alexandre Robaert on 05/02/20.
//  Copyright © 2020 Alexandre Robaert. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var senhaTextField: UITextField!
    @IBOutlet weak var entrarButton: UIButton!
    @IBOutlet weak var loginFacebookButton: UIButton!
    @IBOutlet weak var criarContaButton: UIButton!
    
    let cornerRadiusButtons = CGFloat(integerLiteral: 15)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

    @IBAction func login(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
        
        let navigation = storyboard?.instantiateViewController(withIdentifier: "SegundoNavigationController") as! UINavigationController
        navigationController?.dismiss(animated: false, completion: nil)
        present(navigation, animated: true, completion: nil)
    }
}
