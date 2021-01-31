//
//  ViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 14/12/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {

    @IBOutlet weak var sesionButton: UIButton!
    @IBOutlet weak var registrarsebutton: UIButton!
    
    var email:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sesionButton.layer.cornerRadius = 15
        registrarsebutton.layer.cornerRadius = 15
        validarLogin()
    }
    func validarLogin(){
        if FirebaseAuth.Auth.auth().currentUser != nil {
            let user = Auth.auth().currentUser
            email = (user?.email)!
            performSegue(withIdentifier: "verificarLoginSegue", sender: self)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        validarLogin()
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verificarLoginSegue" {
            let ObjMenu = segue.destination as! MenuViewController
            ObjMenu.correoFire = email
           
        }
    }

}

