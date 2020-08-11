//
//  Details.swift
//  PokemonBlue
//
//  Created by Field Employee on 7/31/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import UIKit

class Details: UIViewController {
    var pokemon: Pokemon?
    lazy var vStackContainer: UIStackView = {
        let vStack = UIStackView(frame: .zero)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.distribution = .fillProportionally
        vStack.axis = .vertical
        return vStack
    }()
    
    lazy var hStackTypes: UIStackView = {
        let hStack = UIStackView(frame: .zero)
        hStack.distribution = .fillEqually
        hStack.axis = .horizontal
        hStack.spacing = 8
        return hStack
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .center
        guard let pokeFont = UIFont(name: "PokemonHollowNormal", size: 33) else {
            print("YOU NEED TO GET THE POKEMONS")
            return nameLabel
        }
        nameLabel.font = pokeFont
        return nameLabel
    }()
    
    lazy var mainImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    init(pokemon: Pokemon) {
        super.init(nibName: nil, bundle: nil)
        self.pokemon = pokemon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var compact: [NSLayoutConstraint] = []
    var regular: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        guard let pokemon = self.pokemon else { return }

        mainImage.image = pokemon.image
        nameLabel.text = pokemon.name.capitalizingFirstLetter()
        
        self.setupType()
        self.setupScroll()
        
        self.view.addSubview(mainImage)
        self.view.addSubview(nameLabel)
        self.view.addSubview(vStackContainer)

        self.setupConstraints()
    }
    
    private func setupConstraints(){
        guard let safeArea = self.view?.safeAreaLayoutGuide else { return }
        
        compact.append(contentsOf: [
            
            nameLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            mainImage.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            
            vStackContainer.heightAnchor.constraint(greaterThanOrEqualTo: safeArea.heightAnchor, multiplier: 0.6),
            vStackContainer.topAnchor.constraint(equalTo: self.mainImage.bottomAnchor, constant: -8),
            vStackContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8)
        ])
        
        regular.append(contentsOf: [
            nameLabel.trailingAnchor.constraint(equalTo: self.vStackContainer.leadingAnchor, constant: 8),
            mainImage.trailingAnchor.constraint(equalTo: self.vStackContainer.leadingAnchor, constant: 8),

            mainImage.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8),
            
            vStackContainer.widthAnchor.constraint(greaterThanOrEqualTo: safeArea.widthAnchor, multiplier: 0.6),
            vStackContainer.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            vStackContainer.trailingAnchor.constraint(equalTo: self.mainImage.trailingAnchor, constant: -8)
        ])
        
        self.setOrientationConstraints()

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            nameLabel.heightAnchor.constraint(equalToConstant: 70),
            
            mainImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            mainImage.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            
            vStackContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            vStackContainer.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8)
        ])

        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.setOrientationConstraints()
    }
    
    private func setOrientationConstraints(){
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            NSLayoutConstraint.activate(compact)
            NSLayoutConstraint.deactivate(regular)
        } else {
            NSLayoutConstraint.activate(regular)
            NSLayoutConstraint.deactivate(compact)
        }
    }
        
    private func setupType() {
        guard let pokemon = self.pokemon else { return }
        pokemon.types.forEach { val in
            guard let bgColor = TypeColors.shared.getColor(type: val.type.name) else {return}
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = val.type.name
            label.textColor = .white
            label.textAlignment = .center
            label.layer.backgroundColor = bgColor.cgColor
            label.layer.cornerRadius = 22
            hStackTypes.addArrangedSubview(label)
            label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        vStackContainer.addArrangedSubview(hStackTypes)
    }
    
    private func setupScroll(){
        guard let pokemon = pokemon else { return }
        let hStackScrolls = UIStackView(frame: .zero)
        hStackScrolls.translatesAutoresizingMaskIntoConstraints = false
        hStackScrolls.axis = .horizontal
        hStackScrolls.distribution = .fillProportionally

        let scrollMoves = genScroll("Moves", arr: pokemon.moves.map{$0.move.name})
        let scrollAbilities = genScroll("Abilites", arr: pokemon.abilities.map{$0.ability.name})
        hStackScrolls.addArrangedSubview(scrollMoves)
        hStackScrolls.addArrangedSubview(scrollAbilities)
        vStackContainer.addArrangedSubview(hStackScrolls)
    }
    
    private func genScroll(_ titleString: String, arr: [String]) -> UIStackView {
        let vStackScroll = UIStackView(frame: .zero)
        vStackScroll.translatesAutoresizingMaskIntoConstraints = false
        vStackScroll.axis = .vertical
        vStackScroll.distribution = .fill
        vStackScroll.spacing = 8
        
        let title = UILabel(frame: .zero)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.text = titleString
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 22)

        
        let vStackMoves = UIStackView(frame: .zero)
        vStackMoves.translatesAutoresizingMaskIntoConstraints = false
        vStackMoves.axis = .vertical
        vStackMoves.distribution = .fill

        let frame = self.view.safeAreaLayoutGuide.layoutFrame
        arr.forEach{ val in
            let label = UILabel(frame: .zero)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = val
            label.textAlignment = .center
            vStackMoves.addArrangedSubview(label)

            label.heightAnchor.constraint(equalToConstant: 20).isActive = true
            label.widthAnchor.constraint(equalToConstant: frame.width/2).isActive = true
        }

        let contentViewSize = CGSize(width: frame.width*0.4 , height: CGFloat(arr.count*20))
        let scroll = UIScrollView(frame: .zero)
        scroll.frame = self.view.bounds
        scroll.contentSize = contentViewSize
        scroll.autoresizingMask = .flexibleHeight
        scroll.bounces = true

        let container = UIView()
        container.frame.size = contentViewSize
         
        container.addSubview(vStackMoves)
        scroll.addSubview(container)
        
        vStackScroll.addArrangedSubview(title)
        vStackScroll.addArrangedSubview(scroll)
        
        return vStackScroll
    }
}
