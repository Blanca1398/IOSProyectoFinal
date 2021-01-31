//
//  JuegoViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 05/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import UIKit
import CoreData

class JuegoViewController: UIViewController, CountriesManagerDelegate {
    
    
    var paisesArray = ["Afghanistan", "Åland%20Islands", "Albania", "Algeria", "American%20Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua%20and%20Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bonaire","Bosnia%20and%20Herzegovina","Botswana","Bouvet%20Island","Brazil","Brunei", "Bulgaria", "Burkina%20Faso", "Burma", "Burundi", "Cabo%20Verde", "Cambodia", "Cameroon", "Canada", "Cayman%20Islands", "Central%20African%20Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo", "Croatia", "Curaçao", "Cuba", "Cyprus", "Czechia", "Denmark", "Djibouti", "Dominica", "Dominican%20Republic", "East%20Timor", "Ecuador", "Egypt", "El%20Salvador", "England", "Equatorial%20Guinea", "Eritrea", "Estonia", "eSwatini", "Ethiopia", "Falkland%20Islands", "Faroe%20Islands", "Fiji", "Finland", "France", "French%20Guiana", "French%20Polynesia", "French%20Southern%20and%20Antarctic%20Lands", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Great%20Britain", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea", "Guyana", "Haiti", "Heard%20and%20McDonald%20Islands", "Holland", "Honduras", "Hong%20Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Isle%20of%20Man", "Israel", "Italy", "Ivory%20Coast", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Keeling%20Islands", "Kenya", "Kiribati", "Korea", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macao", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall%20Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New%20Caledonia", "New%20Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk%20Island", "Northern%20Ireland", "Northern%20Marianas%20Islands", "North%20Korea", "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto%20Rico", "Qatar", "Romania", "Russia", "Rwanda", "Sahrawi", "Saint%20Helena", "Saint%20Lucia", "El%20Salvador", "Samoa", "San%20Marino", "Saudi%20Arabia", "Scotland", "Senegal", "Serbia", "Seychelles", "Sierra%20Leone", "Singapore", "Sint%20Maarten", "Slovakia", "Slovenia", "Solomon%20Islands", "Somalia", "South%20Africa", "South%20Georgia", "South%20Korea", "South%20Sudan", "Spain", "Sri%20Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Togo", "Tokelau", "Tonga", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United%20Arab%20Emirates", "United%20Kingdom", "United%20States%20of%20America", "United%20States", "United%20States%20Virgin%20Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican", "Venezuela", "Vietnam", "Wales", "Western%20Sahara", "Yemen", "Zambia", "Zimbabwe"
    
    ]
    
    var puntosNivel:Int = 0 //Puntos acertados
    var indiceEjercicio:Int = 1 //En que reto va
    var cadenaPuntosNivel = "/10" //label para completar cadena
    var indiceRandom = 0   //Numero random para obtener
    var longitud = 243
    
    var pistaRandom = 0
    var pistaTipo:String? //0 Capital   1 region    2 idioma
    var pistaTipoCadena = ["Capital: ", "Region: ", "Idioma: "]
    var pistaCadena:String?
    var paisCorrecto:String?
    var bandera:String?
    
    
    @IBOutlet weak var paisEjercicioTextfField: UITextField!
    @IBOutlet weak var siguienteButton: UIButton!
    @IBOutlet weak var puntoNivelLabel: UILabel!
    @IBOutlet weak var pistaLabel: UILabel!
    @IBOutlet weak var banderaPais: UIImageView!
    
    @IBOutlet weak var puntosLeyendaLabel: UILabel!
    @IBOutlet weak var TituloLabel: UILabel!
    @IBOutlet weak var PistaLeyendaLabel: UILabel!
    @IBOutlet weak var paisLeyendaLabel: UILabel!
    @IBOutlet weak var numEjercicio: UILabel!
    
    
    var countriesModel=[CountriesModel]()
    var countriesData=[CountriesData]()
    var countriesManager = CountriesManager()
    
    //VARIABLES PARA CORE DATA
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var recibirIndice = -1
    var nivelMayor = 0
    var perfil = [Perfil]()
    var niveles = [Niveles]()
    var nivelesDepurados = [Niveles]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesManager.delegado = self
        siguienteButton.layer.cornerRadius = 15
        
        indiceRandom = Int(arc4random_uniform(UInt32(longitud)))
        
        countriesManager.CatalogoOff()
        countriesManager.fetchAPI(nombre: paisesArray[indiceRandom])
        //countriesManager.fetchAPI(nombre: "Réunion")
        //countriesManager.fetchAPI(nombre: "Taiwan")
        
        
        cargarCoreData()
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
    @IBAction func SiguienteButtonAction(_ sender: UIButton) {
        print("EL INDICE DEL EJERCICIO ES \(indiceEjercicio)")
        if(indiceEjercicio == 11){
            print("ENTRO AL MENU 11")
             indiceEjercicio = 1
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            //self.navigationController?.popViewController(animated: true)
        }
        else if(paisEjercicioTextfField.text != ""){
            if(indiceEjercicio < 10){
                print("ENTRO AL MENU <10")
                print("pais Correcto: \(paisCorrecto)")
                print("pais TextField: \(paisEjercicioTextfField.text)")
                if(paisEjercicioTextfField.text?.uppercased() == paisCorrecto?.uppercased()){
                    puntosNivel = puntosNivel + 1
                    print("PAIS CORRECTO")
                }
                else{
                    print("PAIS INCORRECTO")
                }
                
                indiceEjercicio = indiceEjercicio + 1
                
                paisEjercicioTextfField.text = ""
                numEjercicio.text = String(indiceEjercicio)
                puntoNivelLabel.text = String(puntosNivel) + cadenaPuntosNivel
                
                indiceRandom = Int(arc4random_uniform(UInt32(longitud)))
                countriesManager.CatalogoOff()
                countriesManager.fetchAPI(nombre: paisesArray[indiceRandom])
                
                
            }
            else if (indiceEjercicio == 10){
                print("ENTRO AL MENU 10")
                if(paisEjercicioTextfField.text?.uppercased() == paisCorrecto?.uppercased()){
                    puntosNivel = puntosNivel + 1
                    print("PAIS CORRECTO")
                }
                else{
                    print("PAIS INCORRECTO")
                }
                //Alerta
                let alerta = UIAlertController(title: "Nivel Terminado", message: "Nivel: \(nivelMayor + 1) \nPuntos:\(puntosNivel)", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Entendido", style: .default){ (_) in
                    
                }
                alerta.addAction(actionOk)
                self.present(alerta, animated: true, completion: nil)
                
                limpiarLabels()
               
                
                if(puntosNivel > 7){
                    finJuego(gano: true)
                    //GUARDAR EN EL CORE DATA
                    let nuevoNivel = Niveles(context: self.context)
                    nuevoNivel.nivel = Int64(nivelMayor + 1)
                    nuevoNivel.puntos = Int64(puntosNivel)
                    nuevoNivel.correo = perfil[recibirIndice].correo

                    //Guardamos el contacto
                    self.niveles.append(nuevoNivel)
                    self.guardarCoreData()
                }
                else{
                    finJuego(gano: false)
                }
                indiceEjercicio = indiceEjercicio + 1
                print("DESDE MENU 10 INDICE ---->\(indiceEjercicio)")
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
    
// MARK: - Funciones Auxiliares
    func limpiarLabels() {
        numEjercicio.text = ""
        paisEjercicioTextfField.text = ""
        paisEjercicioTextfField.isHidden = true
        siguienteButton.setTitle("", for: UIControl.State.normal)
        siguienteButton.isHidden = true
        puntoNivelLabel.text = ""
        pistaLabel.text = ""
        banderaPais.image = UIImage(systemName:"airplane")
           
        puntosLeyendaLabel.text = ""
        TituloLabel.text = ""
        PistaLeyendaLabel.text = ""
        paisLeyendaLabel.text = ""
    }
    func finJuego(gano:Bool) {
        if gano == true{
            TituloLabel.text = "Felicidades eres todo un explorador!!!!!!"
            banderaPais.image = UIImage(named: "exploradores.jpg")
        }
        else{
            TituloLabel.text = "Nunca te rindas, siempre puedes volverlo a intentar"
            banderaPais.image = UIImage(named: "ExploradorPerdido.png")
        }
        siguienteButton.isHidden = false
        siguienteButton.setTitle("Ir al menu principal", for: UIControl.State.normal)
        
        
    }
    func reiniciarLabels() {
        numEjercicio.text = "1"
        paisEjercicioTextfField.text = ""
        paisEjercicioTextfField.placeholder = "Recuerda escribirlo en ingles"
        paisEjercicioTextfField.isHidden = false
        siguienteButton.setTitle("Siguiente", for: UIControl.State.normal)
        siguienteButton.isHidden = false
        puntoNivelLabel.text = "0/10"
        pistaLabel.text = ""
        banderaPais.image = UIImage(systemName:"airplane")
           
        puntosLeyendaLabel.text = "Puntos de Nivel"
        TituloLabel.text = "Coloca la informacion que falta"
        PistaLeyendaLabel.text = "Pista: "
        paisLeyendaLabel.text = "Pais: "
    }
    
    func asignarLabelsPais() {
        self.pistaRandom = Int(arc4random_uniform(3))
        self.pistaTipo = self.pistaTipoCadena[self.pistaRandom]
        
        self.paisCorrecto = self.countriesModel[0].pais
        self.bandera = self.countriesModel[0].bandera
        
        switch self.pistaRandom {
        case 0:
            self.pistaCadena = self.countriesModel[0].capital
        case 1:
            self.pistaCadena = self.countriesModel[0].region
        case 2:
            self.pistaCadena = self.countriesModel[0].idioma
        default:
            self.pistaCadena = self.countriesModel[0].capital
        }

        pistaLabel.text = String(pistaTipo ?? "") + String(pistaCadena ?? "")
        
        var url:NSURL?
        var data:NSData?
        var image:UIImage?
        var path = ""
        
        path = "https://www.crwflags.com/art/countries/"
        let paisPath = Array(self.countriesModel[0].pais)
        for character in paisPath {
            if(character != " "){
                path = "\(path)\(character)"
            }
        }
        path = "\(path).gif"
        
        print("El path de la imagen es \(path)")
        
        //Consumiendo la imagen desde la URL
        url = NSURL(string: String(path))
        
        if(url != nil){
            data = NSData(contentsOf : url! as URL)
        }
        
        if(data == nil){
            path = "https://www.crwflags.com/fotw/images/"
            let imgPathArray = Array(self.countriesModel[0].codigo)
            path = "\(path)\(imgPathArray[0])/\(self.countriesModel[0].codigo).gif"
            
            url = NSURL(string: String(path))
            data = NSData(contentsOf : url! as URL)
        }
        
        image = UIImage(data : data! as Data)
        
        print(path)
        
        self.banderaPais.image = image
    }
    
// MARK: - API
    func actualizarPais(pais: [CountriesModel]) {
        DispatchQueue.main.async {
            print("ENTRO A LA ACTUALIZACION")
            self.countriesModel.removeAll()
            self.countriesModel.append(pais[0])
            self.asignarLabelsPais()
         }
    }
    
    func actualizarCatalogo(paises: [CountriesModel]) {
        
    }
    
    func huboError(cualError: Error) {
        print(cualError.localizedDescription)
        
        DispatchQueue.main.async {
            
            if cualError.localizedDescription == "The Internet connection appears to be offline." {
                //Alerta
                let alerta = UIAlertController(title: "Conexion de Internet", message: "Verifique que tenga internet e intentelo de nuevo", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
                alerta.addAction(actionOk)
                self.present(alerta, animated: true, completion: nil)
            }
            else {
                self.indiceRandom = Int(arc4random_uniform(UInt32(self.longitud)))
                
                self.countriesManager.CatalogoOff()
                self.countriesManager.fetchAPI(nombre: self.paisesArray[self.indiceRandom])
            }
        }
    }
    

}
