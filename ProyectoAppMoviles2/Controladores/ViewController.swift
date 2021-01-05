//
//  ViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 14/12/20.
//  Copyright © 2020 Blanca Cordova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let countriesManager = CountriesManager()
    let geoManager = GeoManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        countriesManager.realizarSolicitud()
        geoManager.realizarSolicitud()
        // Do any additional setup after loading the view.
    }


}

