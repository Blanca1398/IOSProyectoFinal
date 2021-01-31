//
//  GeoManager.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 23/12/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import Foundation
protocol GeoManagerDelegate {
    func conversionGeoPais(pais: GeoModel)
    func huboError(cualError: Error)
}

struct GeoManager {
    var delegado: GeoManagerDelegate?
    //GEOLOCALIZACION INVERSA
    var geoURL = "http://api.geonames.org/findNearbyPlaceNameJSON?lat="
    //Paises
    //var moviesURL = "https://restcountries.eu/rest/v2/lang/es"

    
    func realizarSolicitud(lat: Double, long: Double) {
        
        if let url = URL(string: "\(geoURL)\(lat)&lng=\(long)&username=kurisuda13"){
            print("\(geoURL)\(lat)&lng=\(long)&username=kurisuda13")
            let session = URLSession(configuration: .default)
            let tarea = session.dataTask(with: url) { (data, respuesta, error) in
                if error != nil {
                    print(error!)
                    self.delegado?.huboError(cualError: error!)
                    return
                }
                else {
                    if let datosSeguros = data {
                        if let country = self.parseJSON(geoData: datosSeguros) {
                            self.delegado?.conversionGeoPais(pais: country)
                        }
                    }
                }
            }
            tarea.resume()
            
        }
    }


    func parseJSON(geoData: Data) -> GeoModel? {
        let decoder = JSONDecoder()
        do {
            let dataDecodificada = try decoder.decode(GeoData.self, from: geoData)
            let pais = dataDecodificada.geonames[0].countryName
            
            //Crear obj personalizado
            let Obj = GeoModel(pais: pais)
            print("ya lo decodifico")
            return Obj
        } catch {
            print(error)
            delegado?.huboError(cualError: error)
            return nil
        }
    }
}
