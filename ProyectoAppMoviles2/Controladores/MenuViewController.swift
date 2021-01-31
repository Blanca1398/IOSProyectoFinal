//
//  MenuViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 05/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import UIKit
import CoreData
import FirebaseAuth
import Firebase
import FirebaseFirestore
class MenuViewController: UIViewController {

    @IBOutlet weak var perfilButton: UIButton!
    @IBOutlet weak var explorarButton: UIButton!
    @IBOutlet weak var jugarButton: UIButton!
    
    //Info del Usuario
    @IBOutlet weak var correoLabel: UILabel!
    @IBOutlet weak var nombrePerfilLabel: UILabel!
    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var fotoPerfilImg: UIImageView!
    
    //Info del segue para select del FireStore
    var correoFire = ""
    
    //Varibles para FireStore
    var nombreFire = ""
    
    //VARIABLES PARA CORE DATA
    //VARIABLES PARA CORE DATA
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recibirIndice = -1
    var nivelMayor = 0
    var perfil = [Perfil]()
    var niveles = [Niveles]()
    var nivelesDepurados = [Niveles]()
    var coreExist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        perfilButton.layer.cornerRadius = 15
        explorarButton.layer.cornerRadius = 35
        jugarButton.layer.cornerRadius = 35
        
        self.selectFire()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.cargarCoreData()
            print("Nombre desde el view\(self.nombreFire)")
            
            
            if(self.recibirIndice != -1){
                
                self.nivelLabel.text = String (self.nivelMayor)
                
                if (self.perfil[self.recibirIndice].foto != nil){
                    self.fotoPerfilImg.image = UIImage(data: self.perfil[self.recibirIndice].foto! as Data)
                }
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        
        perfilButton.layer.cornerRadius = 15
        explorarButton.layer.cornerRadius = 35
        jugarButton.layer.cornerRadius = 35
        
        self.selectFire()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.cargarCoreData()
            print("Nombre desde el view\(self.nombreFire)")
            
            
            if(self.recibirIndice != -1){
                
                self.nivelLabel.text = String (self.nivelMayor)
                
                if (self.perfil[self.recibirIndice].foto != nil){
                    self.fotoPerfilImg.image = UIImage(data: self.perfil[self.recibirIndice].foto! as Data)
                }
            }
        }
    }
    //MARK:- BD FireStore
    func selectFire() {
        print("Entro al select del FireStore")
        let db =  Firestore.firestore()
        db.collection("perfiles").whereField("correo", isEqualTo: correoFire)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        self.correoFire = document.data()["correo"] as! String
                        self.nombreFire = document.data()["nombre"] as! String
                        print("Del Fire \(document.data()["nombre"] as! String)")
                        print("Del Nombre \(self.nombreFire)")
                        self.nombrePerfilLabel.text = self.nombreFire
                        self.correoLabel.text = self.correoFire
                    }
                }
        }
    }
     //MARK: - Funciones Auxiliares

    
    //MARK: - Botones
    @IBAction func JugarButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "juegoSegue", sender: nil)
    }
    
    @IBAction func PerfilButon(_ sender: Any) {
        self.performSegue(withIdentifier: "perfilSegue", sender: nil)
    }
    
    
    
    @IBAction func CerrarSesionButton(_ sender: UIBarButtonItem) {
            let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
            var errorMensaje:String = ""
            if(signOutError.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted."){
                errorMensaje = "El Usuario no existe"
            }
            else if(signOutError.localizedDescription == "The password is invalid or the user does not have a password."){
                errorMensaje = "La contraseña debe ser de al menos 6 caracteres"
            }
            else if( signOutError.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred."){
                errorMensaje = "No hay conexion a Internet"
            }
            else if( signOutError.localizedDescription == "The email address is badly formatted."){
                errorMensaje = "El correo electronico no esta en el formato correcto"
            }
            else{
                errorMensaje = signOutError.localizedDescription
            }
            //Alerta
            let alerta = UIAlertController(title: "Error al Iniciar Sesion", message: errorMensaje, preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default){ (_) in
                 
            }
            alerta.addAction(actionOk)
            self.present(alerta, animated: true, completion: nil)
        }
          
    }
    
    // MARK: - Core Data
    func cargarCoreData() {
        print("Entro a Core Data")
        //Esta sentencia es equivalente a un select
        let fetchRequest : NSFetchRequest<Perfil> = Perfil.fetchRequest()
        let fetchRequestNiveles : NSFetchRequest<Niveles> = Niveles.fetchRequest()
        do{
            perfil = try context.fetch(fetchRequest)
            print("PERFILES GUARDADOS\n")
            print(perfil)
            niveles = try context.fetch(fetchRequestNiveles)
            if(perfil.count > 0){
                depurarPerfil()
            }
            if (!coreExist){
                let nuevo = Perfil(context: self.context)
                print("nombre del fire desde menu\n\(nombreFire)")
                nuevo.nombre = self.nombreFire
                nuevo.correo = self.correoFire
                
                //Guardamos el contacto
                self.perfil.append(nuevo)
                self.guardarCoreData()
                print("segun lo guardo en el core data")
                
            }
            if(niveles.count > 0){
                depurarNiveles()
                print("Si hay")
            }
            else{
                nivelMayor = 0
                print("Nivel Cero jejes")
            }
            print("Saco la info de Core Data")
            
        } catch let error as NSError {
            print("Error al cargar la info de la base de datos\(error.localizedDescription)")
        }
    }

    func depurarNiveles()  {
        print("Depurando Niveles")
        if niveles.count > 0{
            var i = 0
            for nivel in niveles {
                if(nivel.correo == perfil[recibirIndice].correo){
                    nivelesDepurados.append(nivel)
                }
                else{
                    print("Se encontro de otro usuario")
                }
                i = i + 1
            }
            
            if(nivelesDepurados.count > 0){
                nivelMayor = Int(nivelesDepurados[0].nivel)
                for n in nivelesDepurados {
                    if(nivelMayor < Int(n.nivel)){
                        nivelMayor = Int(n.nivel)
                    }
                }
            }
        }
    }
    func depurarPerfil()  {
        print("Depurando Perfiles")
        print("Correo de Fire\(correoFire)")
        
        if perfil.count > 0{
            var i = 0
            for p in perfil {
                print("Correo del perfil\(String(p.correo ?? ""))")
                if(String(p.correo ?? "") == correoFire){
                    coreExist = true
                    recibirIndice = i
                    print("Recibir indice ------------>\(recibirIndice)")
                }
                i = i + 1
            }
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
        if segue.identifier == "perfilSegue" {
            let Obj = segue.destination as! PerfilViewController
            Obj.recibirIndice = recibirIndice
            print("perfilSegue recibirIndice = \(recibirIndice)")
           
        }
        
        if segue.identifier == "juegoSegue" {
            let Obj = segue.destination as! JuegoViewController
            Obj.recibirIndice = recibirIndice
            print("juegoSegue recibirIndice = \(recibirIndice)")
           
        }
        
        
        
    }
    
    

}
