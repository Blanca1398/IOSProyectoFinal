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
    
    var recibirpais: String?
    var recibircodigo:String?
    var recibircapital:String?
    var recibirregion:String?
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
        //pais.text =  recibirpaisEspanol
        // recibirindice
       
       
       // ImagenPerfil.image = UIImage(data: photos[photos.count-1].savedImage! as Data)
       /*if (contactos[recibirIndice!].perfil != nil){
           ImagenPerfil.image = UIImage(data: contactos[recibirIndice!].perfil! as Data)
           eleccionImagen = true
       }*/
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
