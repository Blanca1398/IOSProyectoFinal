//
//  MoviesManager.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 14/12/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import Foundation
struct MoviesManager {
    //OPENLIBRA
    //var moviesURL = "https://www.etnassoft.com/api/v1/get/?id=589&callback=?"
    //GEOLOCALIZACION INVERSA
    var moviesURL = "http://api.geonames.org/findNearbyPlaceNameJSON?lat=47.3&lng=9&username=kurisuda13"
    //Paises
    //var moviesURL = "https://restcountries.eu/rest/v2/lang/es"
    
    func realizarSolicitud () {
        if let url = URL(string: moviesURL) {
            let session = URLSession(configuration: .default)
            let tarea = session.dataTask(with: url, completionHandler: handle(data:respuesta:error:))
            tarea.resume()
        }
    }
    func handle(data:Data?, respuesta: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        if let datosSeguros = data {
            let dataString: String?  = String(data:datosSeguros, encoding: .utf8)
            
            var datosCorregidos:String = dataString!.replacingOccurrences(of: "\\u00f1", with: "ñ")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00d1", with: "Ñ")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00c1", with: "Á")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00e1", with: "á")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00c9", with: "É")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00e9", with: "é")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00cd", with: "Í")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00ed", with: "í")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00d3", with: "Ó")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00f3", with: "ó")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00da", with: "Ú")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00fa", with: "ú")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00dc", with: "Ü")
            datosCorregidos = datosCorregidos.replacingOccurrences(of: "\\u00fc", with: "ü")
            
            print(datosCorregidos)
        }
        
        
    }
}
