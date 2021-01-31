//
//  ExploradorViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 05/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import UIKit
import CoreData
import WebKit
import FirebaseAuth
import CoreLocation

class ExploradorViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CountriesManagerDelegate, CLLocationManagerDelegate, GeoManagerDelegate {

    
    var countriesModel = [CountriesModel]()
    var countriesData = [CountriesData]()
    
    var countriesManager = CountriesManager()
    var geolocalizacionManager = GeoManager()
    var locationManager = CLLocationManager()

    var paisesArray = ["Afghanistan", "Åland%20Islands", "Albania", "Algeria", "American%20Samoa", "Andorra", "Angola", "Anguilla", "Antarctica", "Antigua%20and%20Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bonaire","Bosnia%20and%20Herzegovina","Botswana","Bouvet%20Island","Brazil","Brunei", "Bulgaria", "Burkina%20Faso", "Burma", "Burundi", "Cabo%20Verde", "Cambodia", "Cameroon", "Canada", "Cayman%20Islands", "Central%20African%20Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo", "Croatia", "Curaçao", "Cuba", "Cyprus", "Czechia", "Denmark", "Djibouti", "Dominica", "Dominican%20Republic", "East%20Timor", "Ecuador", "Egypt", "El%20Salvador", "England", "Equatorial%20Guinea", "Eritrea", "Estonia", "eSwatini", "Ethiopia", "Falkland%20Islands", "Faroe%20Islands", "Fiji", "Finland", "France", "French%20Guiana", "French%20Polynesia", "French%20Southern%20and%20Antarctic%20Lands", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Great%20Britain", "Greece", "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea", "Guyana", "Haiti", "Heard%20and%20McDonald%20Islands", "Holland", "Honduras", "Hong%20Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Isle%20of%20Man", "Israel", "Italy", "Ivory%20Coast", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Keeling%20Islands", "Kenya", "Kiribati", "Korea", "Kosovo", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Macao", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall%20Islands", "Martinique", "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru", "Nepal", "Netherlands", "New%20Caledonia", "New%20Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk%20Island", "Northern%20Ireland", "Northern%20Marianas%20Islands", "North%20Korea", "Norway", "Oman", "Pakistan", "Palau", "Palestine", "Panama", "Papua", "Paraguay", "Peru", "Philippines", "Pitcairn", "Poland", "Portugal", "Puerto%20Rico", "Qatar", "Reunion", "Romania", "Russia", "Rwanda", "Sahrawi", "Saint%20Helena", "Saint%20Lucia", "El%20Salvador", "Samoa", "San%20Marino", "Saudi%20Arabia", "Scotland", "Senegal", "Serbia", "Seychelles", "Sierra%20Leone", "Singapore", "Sint%20Maarten", "Slovakia", "Slovenia", "Solomon%20Islands", "Somalia", "South%20Africa", "South%20Georgia", "South%20Korea", "South%20Sudan", "Spain", "Sri%20Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Togo", "Tokelau", "Tonga", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United%20Arab%20Emirates", "United%20Kingdom", "United%20States%20of%20America", "United%20States", "United%20States%20Virgin%20Islands", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican", "Venezuela", "Vietnam", "Wales", "Western%20Sahara", "Yemen", "Zambia", "Zimbabwe"
    
    ]
    
    var pais: String?
    var codigo:String?
    var capital:String?
    var region:String?
    var bandera:String?
    var paisNativo:String?
    var moneda:String?
    var monedaCodigo:String?
    var monedaSimbolo:String?
    var idioma:String?
    var idiomaNativo:String?
    var paisEspanol:String?
    var indice :Int?
    
    
    @IBOutlet weak var TablaBanderas: UITableView!
    @IBOutlet weak var buscarTextField: UITextField!
    
    
    //VARIABLES PARA CORE DATA
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buscarTextField.delegate = self
        countriesManager.delegado = self
        geolocalizacionManager.delegado = self
        
        //Primero se solicita el permiso
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestLocation()
        
        TablaBanderas.register(UINib(nibName: "CountriesTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        //countriesManager.fetchAPI()
        getCatalogo()
    }


    
    override func viewWillAppear(_ animated: Bool) {
        TablaBanderas.reloadData()
    }
    
    // MARK: - Gps
    @IBAction func GpsButton(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Ubicacion obtenido")
        if let ubicacion = locations.last {
            let lat = ubicacion.coordinate.latitude
            let lon = ubicacion.coordinate.longitude
           
            geolocalizacionManager.realizarSolicitud(lat: lat, long: lon)
            print("lat\(lat) lon\(lon)")
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // MARK: - GeoDelegate
    func conversionGeoPais(pais: GeoModel) {
        print("Entro a la conversion")
        var correccion: String = pais.pais.replacingOccurrences(of: " ", with: "%20")
        if(correccion == "United%20States") {
            correccion = correccion + "%20of%20America"
        }
        countriesManager.CatalogoOff()
        countriesManager.fetchAPI(nombre: correccion)
        print(pais.pais)
    }
    
    // MARK: - Botones
    
    @IBAction func CerrarSesionButton(_ sender: Any) {
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
    
    @IBAction func BuscarBoton(_ sender: UIButton) {
        if buscarTextField.text != "" {
            countriesManager.CatalogoOff()
            let correccion: String = buscarTextField.text!.replacingOccurrences(of: " ", with: "%20")
            countriesManager.fetchAPI(nombre: correccion)
        }
        else {
            //Alerta
            let alerta = UIAlertController(title: "Campo Vacio", message: "Porfavor asegurese de no dejar el campo vacio al buscar", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
            alerta.addAction(actionOk)
            self.present(alerta, animated: true, completion: nil)
        }
    }
    // MARK: - Metodos Auxiliares
    func getCatalogo() {
        countriesModel.removeAll()
        let numPaisesArray = paisesArray.count
        countriesManager.CatalogoOn()
        var i = 0
        for item in paisesArray {
            if(i<20){
              countriesManager.fetchAPI(nombre: item)
            }
            else {
                break
            }
            i = i + 1
            
        }
       
    }

    
    
     // MARK: - Delegado TableView y TableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let celda = TablaBanderas.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountriesTableViewCell
        
        DispatchQueue.main.async {
            
            celda.nombrePaisCeldaLabel.text = self.countriesModel[indexPath.row].pais
            celda.CapitalCeldaLabel.text = self.countriesModel[indexPath.row].capital
            
            if self.countriesModel[indexPath.row].bandera != "" {
                var url:NSURL?
                var data:NSData?
                var image:UIImage?
                var path = ""
                
                path = "https://www.crwflags.com/art/countries/"
                let paisPath = Array(self.countriesModel[indexPath.row].pais)
                for character in paisPath {
                    if(character != " "){
                        path = "\(path)\(character)"
                    }
                }
                path = "\(path).gif"
                
                print("El path de la imagen es \(path)")
                
                //Consumiendo la imagen desde la URL
                url = NSURL(string: String(path))
                data = NSData(contentsOf : url! as URL)
                
                if(data == nil){
                    path = "https://www.crwflags.com/fotw/images/"
                    let imgPathArray = Array(self.countriesModel[indexPath.row].codigo)
                    path = "\(path)\(imgPathArray[0])/\(self.countriesModel[indexPath.row].codigo).gif"
                    
                    url = NSURL(string: String(path))
                    data = NSData(contentsOf : url! as URL)
                }
                image = UIImage(data : data! as Data)
                
                celda.imgBanderaCelda.image = image
                
            }
        }
        return celda
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pais = countriesModel[indexPath.row].pais
        codigo = countriesModel[indexPath.row].codigo
        capital = countriesModel[indexPath.row].capital
        region = countriesModel[indexPath.row].region
        bandera = countriesModel[indexPath.row].bandera
        paisNativo = countriesModel[indexPath.row].paisNativo
        moneda = countriesModel[indexPath.row].moneda
        monedaCodigo = countriesModel[indexPath.row].monedaCodigo
        monedaSimbolo = countriesModel[indexPath.row].monedaSimbolo
        idioma = countriesModel[indexPath.row].idioma
        idiomaNativo = countriesModel[indexPath.row].idiomaNativo
        paisEspanol = countriesModel[indexPath.row].paisEspanol
        indice = indexPath.row
        performSegue(withIdentifier: "mostrarPais", sender: nil)
    }
    
// MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarPais" {
            let ObjPais = segue.destination as! PaisViewController
            ObjPais.recibirpais = pais ?? ""
            ObjPais.recibircodigo = codigo ?? ""
            ObjPais.recibircapital = capital
            ObjPais.recibirregion = region ?? ""
            ObjPais.recibirbandera = bandera
            ObjPais.recibirpaisNativo = paisNativo
            ObjPais.recibirmoneda = moneda
            ObjPais.recibirmonedaCodigo = monedaCodigo
            ObjPais.recibirmonedaSimbolo = monedaSimbolo
            ObjPais.recibiridioma = idioma
            ObjPais.recibiridiomaNativo = idiomaNativo
            ObjPais.recibirpaisEspanol = paisEspanol
            ObjPais.recibirindice = indice
           
        }
    }
    
    // MARK: - TextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        buscarTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if buscarTextField.text != "" {
            countriesManager.CatalogoOff()
            let correccion: String = buscarTextField.text!.replacingOccurrences(of: " ", with: "%20")
            countriesManager.fetchAPI(nombre: correccion)
            return true
        }
        else {
            //Alerta
            let alerta = UIAlertController(title: "Campo Vacio", message: "Porfavor asegurese de no dejar el campo vacio al buscar", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
            alerta.addAction(actionOk)
            self.present(alerta, animated: true, completion: nil)
            return false
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if buscarTextField.text != "" {
            return true
        } else {
            buscarTextField.placeholder = "Escribe una ciudad"
            return false
        }
    }
    
    // MARK: - API - Countries Manager
    func actualizarPais(pais: [CountriesModel]) {
       DispatchQueue.main.async {
        self.countriesModel.removeAll()
        var i = 0
        for item in pais {
            self.countriesModel.append(pais[i])
            i = i + 1
            }
        self.TablaBanderas.reloadData()
        }
        
        
    }
    
    func actualizarCatalogo(paises: [CountriesModel]) {
        DispatchQueue.main.async {
        var i = 0
        for item in paises {
            self.countriesModel.append(paises[i])
            i = i + 1
            }
            
            self.TablaBanderas.reloadData()
        }
        
    }

    //Manejo de Errores
    func huboError(cualError: Error) {
        print(cualError.localizedDescription)
        
        DispatchQueue.main.async {
            
            if ((cualError.localizedDescription == "The data couldn’t be read because it is missing." || cualError.localizedDescription == "The data couldn’t be read because it isn’t in the correct format.") && self.countriesManager.banderaCatalogo == false ){
                //Alerta
                let alerta = UIAlertController(title: "Pais Desconocido", message: "Verifica que el nombre del Pais esta bien escrito e intentalo de nuevo", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
                alerta.addAction(actionOk)
                self.present(alerta, animated: true, completion: nil)
            }
            if cualError.localizedDescription == "The data couldn’t be read because it is missing."  && self.countriesManager.banderaCatalogo == false {
                //Alerta
                let alerta = UIAlertController(title: "Pais Desconocido", message: "Verifica que el nombre del Pais esta bien escrito e intentalo de nuevo", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
                alerta.addAction(actionOk)
                self.present(alerta, animated: true, completion: nil)
            }
            if cualError.localizedDescription == "The Internet connection appears to be offline." {
                //Alerta
                let alerta = UIAlertController(title: "Conexion de Internet", message: "Verifique que tenga internet e intentelo de nuevo", preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "Entendido", style: .default, handler: nil)
                alerta.addAction(actionOk)
                self.present(alerta, animated: true, completion: nil)
            }
        }
    }
}




