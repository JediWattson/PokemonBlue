//
//  TypeColors.swift
//  PokemonBlue
//
//  Created by Field Employee on 8/1/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import UIKit

class TypeColors {
    static let shared = TypeColors()
    let colors: [String: UIColor] = [
        "rock": UIColor(red: 187/255, green: 170/255, blue: 102/255, alpha: 1),
        "ghost": UIColor(red: 102/255, green: 102/255, blue: 187/255, alpha: 1),
        "fighting": UIColor(red: 187/255, green: 85/255, blue: 68/255, alpha: 1),
        "ice": UIColor(red: 102/255, green: 204/255, blue: 255/255, alpha: 1),
        "bug": UIColor(red: 170/255, green: 187/255, blue: 34/255, alpha: 1),
        "normal": UIColor(red: 170/255, green: 170/255, blue: 153/255, alpha: 1),
        "fire": UIColor(red: 255/255, green: 68/255, blue: 34/255, alpha: 0.5),
        "water": UIColor(red: 51/255, green: 153/255, blue: 255/255, alpha: 1),
        "electric": UIColor(red: 255/255, green: 204/255, blue: 51/255, alpha: 1),
        "grass": UIColor(red: 119/255, green: 204/255, blue: 85/255, alpha: 1),
        "poison": UIColor(red: 170/255, green: 85/255, blue: 153/255, alpha: 1),
        "ground": UIColor(red: 221/255, green: 187/255, blue: 85/255, alpha: 1),
        "flying": UIColor(red: 136/255, green: 153/255, blue: 255/255, alpha: 1),
        "psychic": UIColor(red: 255/255, green: 85/255, blue: 153/255, alpha: 1),
        "dragon": UIColor(red: 119/255, green: 102/255, blue: 238/255, alpha: 1),
        "dark": UIColor(red: 119/255, green: 85/255, blue: 68/255, alpha: 1),
        "steel": UIColor(red: 170/255, green: 170/255, blue: 187/255, alpha: 1),
        "fairy": UIColor(red: 238/255, green: 153/255, blue: 238/255, alpha: 1)
    ]
    private init(){}
    
    func getColor(type: String) -> UIColor?{
        return colors[type]
    }
    
}
