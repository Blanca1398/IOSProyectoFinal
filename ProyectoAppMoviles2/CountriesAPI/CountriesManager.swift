//
//  CountriesManager.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 23/12/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import Foundation

protocol CountriesManagerDelegate {
    func actualizarPais(pais: [CountriesModel])
    func actualizarCatalogo(paises:[CountriesModel])
    func huboError(cualError: Error)
}

struct CountriesManager {
    var delegado: CountriesManagerDelegate?
    var UrlAPI = "https://restcountries.eu/rest/v2/"
    var banderaCatalogo:Bool = false
    
    mutating func CatalogoOn()  {
        banderaCatalogo = true
    }
    mutating func CatalogoOff()  {
        banderaCatalogo = false
    }
    
    //Obtener pais por nombre
    func fetchAPI(nombre: String) {
        let urlString = "\(UrlAPI)name/\(nombre)"
        print(urlString)
        realizarSolicitud(urlString: urlString)
    }
    //Obtener un listado de paises
    func fetchAPI() {
        let urlString = "https://restcountries.eu/rest/v2/all"
        realizarSolicitud(urlString: urlString)
    }
    
    func fetchAPIbyCode(code:Int){
       let urlString = "\(UrlAPI)callingcode/\(code)"
        realizarSolicitud(urlString: urlString)
    }
    
    func realizarSolicitud(urlString: String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let tarea = session.dataTask(with: url) { (data, respuesta, error) in
                if error != nil {
                    print(error!)
                    self.delegado?.huboError(cualError: error!)
                    return
                }
                if(self.banderaCatalogo == false){
                    if let datosSeguros = data {
                        if let countries = self.parseJSON(countriesData: datosSeguros) {
                            self.delegado?.actualizarPais(pais: countries)
                        }
                    }
                }
                else {
                    if let datosSeguros = data {
                        if let countries = self.parseJSON(countriesData: datosSeguros) {
                            self.delegado?.actualizarCatalogo(paises: countries)
                        }
                    }
                }
            }
            tarea.resume()
        }
    }


    func parseJSON(countriesData: Data) -> [CountriesModel]? {
        let decoder = JSONDecoder()
        do {
            let dataDecodificada = try decoder.decode([CountriesData].self, from: countriesData)
            var numElementos = dataDecodificada.count
            var ObjArray = [CountriesModel]()
            var i = 0
            for item in dataDecodificada {
                let Obj = CountriesModel(pais: item.name, codigo: item.alpha2Code, capital: item.capital, region: item.region, bandera: item.flag, paisNativo:item.nativeName, moneda: item.currencies[0].name, monedaCodigo: item.currencies[0].code, monedaSimbolo: item.currencies[0].symbol, idioma: item.languages[0].name, idiomaNativo: item.languages[0].nativeName, paisEspanol: item.translations.es)
                ObjArray.append(Obj)
                i = i + 1
            }
            
            print(ObjArray)
            return ObjArray
            
        } catch {
            print(error.self)
            delegado?.huboError(cualError: error)
            return nil
        }
    }
    
    
    
    
}
