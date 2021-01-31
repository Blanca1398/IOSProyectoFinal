//
//  HomeViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 30/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let label : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight:.bold)
        label.text = "Ven a explorar el mundo!"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        label.center = view.center
        view.backgroundColor = .systemBackground
        
        
    }


}
