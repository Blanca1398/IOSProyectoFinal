//
//  CountriesTableViewCell.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 09/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import UIKit

class CountriesTableViewCell: UITableViewCell {

    @IBOutlet weak var nombrePaisCeldaLabel: UILabel!
    
    @IBOutlet weak var CapitalCeldaLabel: UILabel!
    
    @IBOutlet weak var imgBanderaCelda: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
