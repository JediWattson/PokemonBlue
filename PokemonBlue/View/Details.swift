//
//  Details.swift
//  PokemonBlue
//
//  Created by Field Employee on 7/31/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import UIKit

class Details: UIViewController {
    var sprite: UIImageView?
    var name: UILabel?
    var typeLabels: [UILabel]?
    var vStack: UIStackView?
    var hStackType: UIStackView?
    var pokemon: Pokemon?
    
    init(pokemon: Pokemon) {
        super.init(nibName: nil, bundle: nil)
        self.pokemon = pokemon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        guard let pokemon = self.pokemon else { return }
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = pokemon.image

        let nameLabel = UILabel(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        guard let pokeFont = UIFont(name: "PokemonHollowNormal", size: 33) else {
            print("YOU NEED TO GET THE POKEMONS")
            return
        }
        nameLabel.font = pokeFont
        nameLabel.text = pokemon.name


        let vStack0 = UIStackView(frame: .zero)
        vStack0.translatesAutoresizingMaskIntoConstraints = false
        vStack0.distribution = .fillProportionally
        vStack0.axis = .vertical
        vStack0.addArrangedSubview(nameLabel)
        vStack0.addArrangedSubview(image)

        var typeLabels: [UILabel] = []
        let hStack = UIStackView(frame: .zero)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.distribution = .fillEqually
        hStack.axis = .horizontal
        hStack.spacing = 16

        pokemon.types.forEach { val in
            guard let bgColor = TypeColors.shared.getColor(type: val.type.name) else {return}
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = val.type.name
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.layer.backgroundColor = bgColor.cgColor
            label.layer.cornerRadius = 22
            typeLabels.append(label)
            hStack.addArrangedSubview(label)
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }

        vStack0.addArrangedSubview(hStack)

        self.view.addSubview(vStack0)

        guard let safeArea = self.view?.safeAreaLayoutGuide else { return }
        
        vStack0.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8).isActive = true
        vStack0.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8).isActive = true
        vStack0.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8).isActive = true
        vStack0.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8).isActive = true
        
        self.vStack = vStack0

    }
}
