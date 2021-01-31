//
//  RegistrarViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 30/12/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class RegistrarViewController: UIViewController {

    @IBOutlet weak var registrarseButton: UIButton!
    
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var correoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var perfil = [Perfil]()
    var correoFire = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registrarseButton.layer.cornerRadius = 15
    }
    // MARK: - Botones
    @IBAction func botonRegistrarse(_ sender: UIButton) {
        
        if(nombreTextField.text != "" && correoTextField.text != "" && passwordTextField.text != ""){
            Auth.auth().createUser(withEmail: correoTextField.text!, password: passwordTextField.text!) { authResult, error in
                if let error = error {
                    var errorMensaje:String = ""
                    if(error.localizedDescription == "The password is invalid or the user does not have a password."){
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
                    let alerta = UIAlertController(title: "Error al Registrar nuevo Usuario", message: errorMensaje, preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default){ (_) in
                        
                    }
                    alerta.addAction(actionOk)
                    self.present(alerta, animated: true, completion: nil)
                }
                else{
                    //Alerta
                    let db = Firestore.firestore()
                    db.collection("perfiles").document(self.correoTextField.text!).setData([
                        "correo": self.correoTextField.text!,
                        "nombre": self.nombreTextField.text!
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    //Agregando valores a nuestra entidad
                    let nuevo = Perfil(context: self.context)
                    nuevo.nombre = self.nombreTextField.text!
                    nuevo.correo = self.correoTextField.text!
                    
                    //Guardamos el contacto
                    self.perfil.append(nuevo)
                    self.guardarCoreData()
                    self.correoFire = self.correoTextField.text!
                    
                    let alerta = UIAlertController(title: "Usuario Registrado ", message: "Correo: \(self.correoTextField.text!)", preferredStyle: .alert)
                    let actionOk = UIAlertAction(title: "Ok", style: .default){ (_) in
                        
                         self.performSegue(withIdentifier: "registroSegue", sender: self)
                        
                        
                    }
                    alerta.addAction(actionOk)
                    self.present(alerta, animated: true, completion: nil)
                }
                
            }
        }
        else {
            //Alerta
            let alerta = UIAlertController(title: "Campos Vacios", message: "No se permiten campos vacios, por favor rellene los campos requeridos", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Entendido", style: .default){ (_) in
                
                
            }
            alerta.addAction(actionOk)
            self.present(alerta, animated: true, completion: nil)
            
        }
        
    }
    
    // MARK: - CORE DATA
    func cargarCoreData() {
        print("Entro a Core Data")
        //Esta sentencia es equivalente a un select
        let fetchRequest : NSFetchRequest<Perfil> = Perfil.fetchRequest()
        do{
            perfil = try context.fetch(fetchRequest)
            
            print("Saco la info de Core Data")
            
        } catch let error as NSError {
            print("Error al cargar la info de la base de datos\(error.localizedDescription)")
        }
    }
    
    func guardarCoreData(){
        do{

            try self.context.save()
            self.cargarCoreData()
            
        } catch let error as NSError {

            let alerta = UIAlertController(title: "Error", message: "Hubo un error al guardar", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
            alerta.addAction(actionOk)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    
    // MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registroSegue" {
            let ObjMenu = segue.destination as! MenuViewController
            ObjMenu.correoFire = correoFire
           
        }
    }
}
