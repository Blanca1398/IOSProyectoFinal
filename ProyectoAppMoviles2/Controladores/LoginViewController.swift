//
//  LoginViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 30/12/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class LoginViewController: UIViewController {

    @IBOutlet weak var sesionButton: UIButton!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var perfilesFire = [Perfil]()
    var correoFire:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        sesionButton.layer.cornerRadius = 15
    }
    //MARK:- BD FireStore
    func selectFire() {
        let db =  Firestore.firestore()
        db.collection("perfiles").whereField("correo", isEqualTo: correoTextField.text)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.correoFire = document.data()["correo"] as! String
                        print(self.correoFire)
                    }
                }
        }
    }

    //MARK: - Botones
    @IBAction func SesionButton(_ sender: Any) {
        
        
        if(correoTextField.text != "" && passwordTextField.text != ""){
            Auth.auth().signIn(withEmail: correoTextField.text!, password: passwordTextField.text!) { authResult, error in
                if let error = error {
                    var errorMensaje:String = ""
                    if(error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."){
                        errorMensaje = "El Usuario no existe"
                    }
                    else if(error.localizedDescription == "The password is invalid or the user does not have a password."){
                        errorMensaje = "La contraseña debe ser de al menos 6 caracteres"
                    }
                    else if( error.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred."){
                        errorMensaje = "No hay conexion a Internet"
                    }
                    else if( error.localizedDescription == "The email address is badly formatted."){
                        errorMensaje = "El correo electronico no esta en el formato correcto"
                    }
                    else{
                        errorMensaje = error.localizedDescription
                    }
                    
                    //Alerta
                    let alerta = UIAlertController(title: "Error al Iniciar Sesion", message: errorMensaje, preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default){ (_) in
                        print(error.localizedDescription)
                    }
                    alerta.addAction(actionOk)
                    self.present(alerta, animated: true, completion: nil)
                }
                else{
                    self.correoFire = self.correoTextField.text!
                    self.performSegue(withIdentifier: "sesionSegue", sender: nil)
                }
            }

        }
        else{
            //Alerta
            let alerta = UIAlertController(title: "Campos Vacios", message: "No se permiten campos vacios, por favor rellene los campos requeridos", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Entendido", style: .default){ (_) in
                
                
            }
            alerta.addAction(actionOk)
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sesionSegue" {
            let ObjMenu = segue.destination as! MenuViewController
            ObjMenu.correoFire = correoFire
           
        }
    }

}
