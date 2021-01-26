//
//  CountriesData.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 07/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import Foundation
struct CountriesData:Codable {
    let name: String
    let capital:String
    let alpha2Code:String
    let region:String
    let flag:String
    let nativeName:String
    let currencies:[Currencies]
    let languages:[Languages]
    let translations:Translations
}

struct Currencies:Codable {
    let code:String
    let name:String
    let symbol:String
}

struct Languages:Codable{
    let name:String
    let nativeName:String
}

struct Translations:Codable{
    let es:String
}
