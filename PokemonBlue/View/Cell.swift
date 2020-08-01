//
//  Cell.swift
//  PokemonBlue
//
//  Created by Field Employee on 7/31/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    static let reuseId: String = "Cell"
    var sprite: UIImageView?
    var name: UILabel?
    var typeLabels: [UILabel]?
    var vStack: UIStackView?
    var hStackType: UIStackView?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTypes(types: [Types]){
        var typeLabels: [UILabel] = []
        self.hStackType?.removeFromSuperview()
        let hStack = UIStackView(frame: .zero)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.distribution = .fillEqually
        hStack.axis = .horizontal
        hStack.spacing = 16
                
        types.forEach { val in
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
        self.hStackType = hStack
        self.typeLabels = typeLabels
        self.vStack?.addArrangedSubview(hStack)
        
    }
    
    func clearCell() {
        let named: String = "MissingNo."
        self.sprite?.image = UIImage(named: named)
        self.name?.text = named
        self.hStackType?.removeFromSuperview()
    }
    
    func setCell(_ pokemon: Pokemon){
        self.sprite?.image = pokemon.image
        self.name?.text = pokemon.name.capitalizingFirstLetter()
        self.setTypes(types: pokemon.types)
    }
    
    private func setup(){
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        
        let nameLabel = UILabel(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        guard let pokeFont = UIFont(name: "PokemonHollowNormal", size: 33) else {
            print("YOU NEED TO GET THE POKEMONS")
            return
            
        }
        nameLabel.font = pokeFont

        let vStack0 = UIStackView(frame: .zero)
        vStack0.translatesAutoresizingMaskIntoConstraints = false
        vStack0.distribution = .fill
        vStack0.axis = .vertical
        vStack0.addArrangedSubview(nameLabel)
        
        self.contentView.addSubview(image)
        self.contentView.addSubview(vStack0)
        
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
        vStack0.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        vStack0.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 8).isActive = true
        vStack0.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        vStack0.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
        self.sprite = image
        self.name = nameLabel
        self.vStack = vStack0
    }
    
}
