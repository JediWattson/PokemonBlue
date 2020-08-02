//
//  UIViewControler+Utils.swift
//  PokemonBlue
//
//  Created by Field Employee on 8/2/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(error: NetworkError) {
        let alert = UIAlertController(title: "NO NO NO NO NO NO!", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Yes me Lord", style: .default, handler: nil)
        alert.addAction(action)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
}
