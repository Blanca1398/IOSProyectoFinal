//
//  PerfilViewController.swift
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

class PerfilViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var TablaNiveles: UITableView!
    @IBOutlet weak var guardarButton: UIButton!
    @IBOutlet weak var ImgPerfilImageView: UIImageView!
    @IBOutlet weak var nombrePerfilTextField: UITextField!
    @IBOutlet weak var nivelTextField: UILabel!
    @IBOutlet weak var CorreoLabel: UILabel!
    
    //VARIABLES PARA CORE DATA
    var eleccionImagen : Bool = false
    var recibirIndice = -1
    var indiceNiveles:Int?
    var nivelMayor = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var perfil = [Perfil]()
    var niveles = [Niveles]()
    var nivelesDepurados = [Niveles]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Delegados
        TablaNiveles.dataSource = self
        TablaNiveles.delegate =  self
        guardarButton.layer.cornerRadius = 15
        
        cargarCoreData()
        
        if(recibirIndice != -1){
            nombrePerfilTextField.text = perfil[recibirIndice].nombre
            print("El nombre en el core data es\n\(perfil[recibirIndice].nombre)")
            var correo = String (perfil[recibirIndice].correo ?? "")
            CorreoLabel.text = "Correo: \(correo)"
            nivelTextField.text = String (nivelMayor)
            
            if (perfil[recibirIndice].foto != nil){
                ImgPerfilImageView.image = UIImage(data: perfil[recibirIndice].foto! as Data)
                eleccionImagen = true
            }
        }
        //PERFILES
        /*let nuevoContacto = Perfil(context: self.context)
        nuevoContacto.nombre = "Blanca"
        nuevoContacto.correo = "blanca@gmail.com"

        //Guardamos el contacto
        self.perfil.append(nuevoContacto)
        self.guardarCoreData()*/
        
        //NIVELES
        /*let nuevoContacto = Niveles(context: self.context)
        nuevoContacto.nivel = 2
        nuevoContacto.puntos = 9
        nuevoContacto.correo = "blanca@gmail.com"

        //Guardamos el contacto
        self.niveles.append(nuevoContacto)
        self.guardarCoreData()*/
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        TablaNiveles.reloadData()
        print("VIEW WILL APPEAR")
    }
    
    // MARK: - Core Data
    func cargarCoreData() {
        //Esta sentencia es equivalente a un select
        let fetchRequest : NSFetchRequest<Perfil> = Perfil.fetchRequest()
        let fetchRequestNiveles : NSFetchRequest<Niveles> = Niveles.fetchRequest()
        do{
            perfil = try context.fetch(fetchRequest)
            niveles = try context.fetch(fetchRequestNiveles)
            if(niveles.count>0){
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
    
    // MARK: - Botones
    
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
    
    @IBAction func EliminarPerfil(_ sender: UIButton) {
        print("ENTRO A ELIMINAR")
        print("recibirIndice = \(recibirIndice)")
        
        
        if(recibirIndice != -1){
            let db = Firestore.firestore()
             print(CorreoLabel.text!)
            db.collection("perfiles").document(perfil[recibirIndice].correo!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                     print("ELIMINO LA COLECCION")
                    let user = Auth.auth().currentUser
                    user?.delete { error in
                      if let error = error {
                        // An error happened.
                      } else {
                         print("ELIMINO EL PERFIL")
                        self.context.delete(self.perfil[self.recibirIndice])
                        self.perfil.remove(at: self.recibirIndice)
                        
                        do{

                            try self.context.save()
                            
                        } catch let error as NSError {

                            let alerta = UIAlertController(title: "Error", message: "Hubo un error al guardar", preferredStyle: .alert)
                            let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
                            alerta.addAction(actionOk)
                            self.present(alerta, animated: true, completion: nil)
                        }
                        
                        print("ELIMINO EL PERFIL DE CORE DATA")
                         self.CerrarSesionFunc()
                        
                      }
                    }
                }
            }
            
            
            
            
        }
    }
    
    func CerrarSesionFunc() {
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
    
    
    
    @IBAction func cambiarFotos(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
               
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func GuardarCambios(_ sender: UIButton) {
       //Variables para validar si los campos son vacios o no
       let nombre : String = nombrePerfilTextField.text!
       
       if (nombre != ""  && recibirIndice != -1){
           do{
               //Imagen
               var image: UIImage?=nil
               image = ImgPerfilImageView.image
              // photoObject.savedImage = image?.jpegData(compressionQuality: 1) as Data?
               
               perfil[recibirIndice].setValue(nombrePerfilTextField.text, forKey: "nombre")
               
           
               if eleccionImagen == true {
                   perfil[recibirIndice].setValue(image?.jpegData(compressionQuality: 1) as Data?, forKey: "foto")
               }
               try self.context.save()
                let db = Firestore.firestore()
                let batch = db.batch()
                let sfRef = db.collection("perfiles").document(perfil[recibirIndice].correo!)
                sfRef.updateData(["nombre": perfil[recibirIndice].nombre! ])
                print("Se guardaron los cambios correctamente")
                print("El correo que busco\(perfil[recibirIndice].correo!)")
               
           } catch {
               nombrePerfilTextField.text = ""
               print(error.localizedDescription)
           }
           
           
           //Alerta
           let alerta = UIAlertController(title: "Cambios Guardados", message: "Nombre : \(nombre) ", preferredStyle: .alert)
           let actionOk = UIAlertAction(title: "Entendido", style: .default){ (_) in
               self.navigationController?.popViewController(animated: true)
           }
           alerta.addAction(actionOk)
           self.present(alerta, animated: true, completion: nil)
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
    
    
    // MARK: - Image Picker Controller
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           picker.dismiss(animated: true, completion: nil)
           
           //Alerta
           let alertaFotoVacia = UIAlertController(title: "No Foto", message: "No elegiste ninguna foto", preferredStyle: .alert)
           
           let actionOK = UIAlertAction(title: "Entendido", style: .default, handler: nil)
           alertaFotoVacia.addAction(actionOK)
           
           self.present(alertaFotoVacia, animated: true, completion: nil)
       }
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           
           if let image =  info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
               ImgPerfilImageView.image = image
               eleccionImagen = true
               
           }
           
           picker.dismiss(animated: true, completion: nil)
           
           //Alerta
           let alertaFoto = UIAlertController(title: "Foto", message: "Wow!!! Esa foto es genial!!", preferredStyle: .alert)
           
           let actionOK = UIAlertAction(title: "Entendido", style: .default, handler: nil)
           alertaFoto.addAction(actionOK)
           
           self.present(alertaFoto, animated: true, completion: nil)
           
       }
    
    // MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nivelesDepurados.count
        
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("ASIGNO VALORES")
        let celda = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        celda.detailTextLabel?.text = "Puntos \(String (nivelesDepurados[indexPath.row].puntos))"
        celda.textLabel?.text = "Nivel \(String (nivelesDepurados[indexPath.row].nivel))"
        //celda.detailTextLabel?.text = "Titulo"
        //celda.textLabel?.text = "Subtitulo"
        
        return celda
    }
}
