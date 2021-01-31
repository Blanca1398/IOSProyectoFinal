//
//  LaunchViewController.swift
//  ProyectoAppMoviles2
//
//  Created by Blanca Cordova on 30/01/21.
//  Copyright © 2021 Blanca Cordova. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    private let imageView : UIImageView = {
           let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
           imageView.image = UIImage(named: "tierra.png")
           return imageView
       }()
    let label : UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight:.bold)
        label.text = "Ven a explorar el mundo!"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.animate()
        })
        
    }
    
    func animate() {
        UIView.animate(withDuration: 1, animations: {
            let size =  self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(x: -diffX/2, y: diffY/2, width: size, height: size)
            
        })
        UIView.animate(withDuration: 1.5, animations: {
            self.imageView.alpha = 0
        }, completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self.view.addSubview(self.label)
                    self.label.center = self.view.center
                    self.view.backgroundColor = .systemBackground
                    /*let viewController = HomeViewController()
                    viewController.modalTransitionStyle = .crossDissolve
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)*/
                    
                })
            }
            
            
        }
        )
        self.performSegue(withIdentifier: "rootSegue", sender: nil)
        
    }


}
