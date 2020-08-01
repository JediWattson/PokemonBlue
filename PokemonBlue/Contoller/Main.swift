//
//  Main.swift
//  PokemonBlue
//
//  Created by Field Employee on 7/31/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import AVFoundation
import UIKit

class MainController: UIViewController {
    var themeSong: AVAudioPlayer?
    var tableView: UITableView?
    var pokemonFetches: [NameLink] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }
    }
    var pokemonFetched: [Pokemon] = []
    var limit: Int = 30
    var nextPage: String = "https://pokeapi.co/api/v2/pokemon?offset=0&limit="
    var previousPage: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.fetchPokemonList(url: "\(self.nextPage)\(self.limit)")
    }
    
    private func setup(){
        let path = Bundle.main.path(forResource: "Pokemon", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)

        do {
            themeSong = try AVAudioPlayer(contentsOf: url)
            //themeSong?.play()
        } catch {
            print(error)
        }
        
        self.view.backgroundColor = .white
        
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        
        table.delegate = self
        table.dataSource = self
        table.register(Cell.self, forCellReuseIdentifier: Cell.reuseId)
        
        self.view.addSubview(table)
        table.boundToSuperView()
        self.tableView = table
    }
    
    func fetchPokemonList(url: String){
        NetworkManager.shared.fetchPokemonList(url){ pokemon in
            self.previousPage = pokemon?.previous ?? ""
            self.nextPage = pokemon?.next ?? ""
            guard let results = pokemon?.results else { return }
            self.pokemonFetches.append(contentsOf: results)
            
        }
    }
}

extension MainController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemonFetches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseId, for: indexPath) as? Cell
        else { return UITableViewCell() }
        
        let url = pokemonFetches[indexPath.row].url

        cell.clearCell()
        
        NetworkManager.shared.fetchPokemon(url){pokemon in
            guard
                var pokemon = pokemon,
                let frontDefault = pokemon.sprites.frontDefault
            else {return}

            NetworkManager.shared.fetchSprite(frontDefault){ image in
                guard let image = image else {return}
                pokemon.image = image
                self.pokemonFetched.append(pokemon)
                DispatchQueue.main.async {
                    cell.setCell(pokemon)
                }
            }
        }
        
        return cell
        
    }

}



extension MainController: UITableViewDelegate {
    
}
