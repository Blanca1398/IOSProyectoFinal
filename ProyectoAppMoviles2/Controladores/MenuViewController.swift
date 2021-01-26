//
//  MenuViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 05/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import UIKit
import CoreData
class MenuViewController: UIViewController {

    @IBOutlet weak var perfilButton: UIButton!
    @IBOutlet weak var explorarButton: UIButton!
    @IBOutlet weak var jugarButton: UIButton!
    
    //Info del Usuario
    @IBOutlet weak var nombrePerfilLabel: UILabel!
    @IBOutlet weak var nivelLabel: UILabel!
    @IBOutlet weak var fotoPerfilImg: UIImageView!
    
    
    //VARIABLES PARA CORE DATA
    //VARIABLES PARA CORE DATA
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recibirIndice = 0
    var nivelMayor = 0
    var perfil = [Perfil]()
    var niveles = [Niveles]()
    var nivelesDepurados = [Niveles]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        perfilButton.layer.cornerRadius = 15
        explorarButton.layer.cornerRadius = 35
        jugarButton.layer.cornerRadius = 35
        
        cargarCoreData()
        
        if(recibirIndice != -1){
            nombrePerfilLabel.text = perfil[recibirIndice].nombre
            nivelLabel.text = String (nivelMayor)
            
            if (perfil[recibirIndice].foto != nil){
                fotoPerfilImg.image = UIImage(data: perfil[recibirIndice].foto! as Data)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        cargarCoreData()
        
        if(recibirIndice != -1){
            nombrePerfilLabel.text = perfil[recibirIndice].nombre
            nivelLabel.text = String (nivelMayor)
            
            if (perfil[recibirIndice].foto != nil){
                fotoPerfilImg.image = UIImage(data: perfil[recibirIndice].foto! as Data)
            }
        }
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
    

}
