//
//  PaisViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 18/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import UIKit

class PaisViewController: UIViewController {

    @IBOutlet weak var pais: UILabel!
    @IBOutlet weak var paisNativo: UILabel!
    @IBOutlet weak var banderaImg: UIImageView!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var continente: UILabel!
    @IBOutlet weak var continenteImg: UIImageView!
    @IBOutlet weak var codigoMoneda: UILabel!
    @IBOutlet weak var nombreMoneda: UILabel!
    @IBOutlet weak var simboloMoneda: UILabel!
    @IBOutlet weak var idioma: UILabel!
    @IBOutlet weak var idiomaNativo: UILabel!
    
    var recibirpais: String = ""
    var recibircodigo:String = ""
    var recibircapital:String?
    var recibirregion:String = ""
    var recibirbandera:String?
    var recibirpaisNativo:String?
    var recibirmoneda:String?
    var recibirmonedaCodigo:String?
    var recibirmonedaSimbolo:String?
    var recibiridioma:String?
    var recibiridiomaNativo:String?
    var recibirpaisEspanol:String?
    var recibirindice :Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pais.text = recibirpais
        codigoMoneda.text = recibircodigo
        capital.text = recibircapital
        continente.text = recibirregion
        paisNativo.text = recibirpaisNativo
        nombreMoneda.text = recibirmoneda
        codigoMoneda.text = recibirmonedaCodigo
        simboloMoneda.text = recibirmonedaSimbolo
        idioma.text = recibiridioma
        idiomaNativo.text = recibiridiomaNativo
        
        //Bandera
        if recibirbandera != "" {
            var url:NSURL?
            var data:NSData?
            var image:UIImage?
            var path = ""
            
            path = "https://www.crwflags.com/art/countries/"
            let paisPath = recibirpais
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
                let imgPathArray = Array(recibircodigo)
                path = "\(path)\(imgPathArray[0])/\(recibircodigo).gif"
                
                url = NSURL(string: String(path))
                data = NSData(contentsOf : url! as URL)
            }
            image = UIImage(data : data! as Data)
            
            banderaImg.image = image
            
        }
        
        if recibirregion.lowercased().contains("europe"){
            continenteImg.image = UIImage(named: "europa.png")
        }
        else if recibirregion.lowercased().contains("africa"){
            continenteImg.image = UIImage(named: "africa.png")
        }
        else if recibirregion.lowercased().contains("americas"){
            continenteImg.image = UIImage(named: "america.png")
        }
        else if recibirregion.lowercased().contains("asia"){
            continenteImg.image = UIImage(named: "asia.png")
        }
        else if recibirregion.lowercased().contains("oceania"){
            continenteImg.image = UIImage(named: "oceania.png")
        }
        else if recibirregion.lowercased().contains("polar"){
            continenteImg.image = UIImage(named: "polar.png")
        }
        else{
           continenteImg.image = UIImage(named: "mapa.jpg")
        }
        
    }
    

}
