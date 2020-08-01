//
//  String+Utils.swift
//  PokemonBlue
//
//  Created by Field Employee on 8/1/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
