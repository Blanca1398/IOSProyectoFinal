//
//  GeoData.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 07/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import Foundation
struct GeoData:Codable {
    let geonames: [Geonames]
}

struct Geonames:Codable {
    let countryName:String
}
