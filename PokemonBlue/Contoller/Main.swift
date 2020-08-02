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
    var pokemonFetched: [String: Pokemon] = [:]
    var limit: Int = 25
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
        table.prefetchDataSource = self
        
        table.register(Cell.self, forCellReuseIdentifier: Cell.reuseId)
        
        self.view.addSubview(table)
        table.boundToSuperView()
        self.tableView = table
    }
    
    func fetchPokemonList(url: String){
        NetworkManager.shared.fetchPokemonList(url){ result in
            switch result {
            case .success(let pokemon):
                self.previousPage = pokemon.previous ?? self.previousPage
                self.nextPage = pokemon.next ?? self.nextPage
                self.pokemonFetches.append(contentsOf: pokemon.results)
            case .failure(let error):
                self.presentAlert(error: error)
            }
            
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
        
        NetworkManager.shared.fetchPokemon(url){result in
            switch result {
            case .success(var pokemon):
                guard let frontDefault = pokemon.sprites.frontDefault else {return}
                NetworkManager.shared.fetchSprite(frontDefault){ result in
                    switch result {
                    case .success(let image):
                        pokemon.image = image
                        self.pokemonFetched[pokemon.name] = pokemon
                        DispatchQueue.main.async {
                            cell.setCell(pokemon)
                        }
                    case .failure(let error):
                        self.presentAlert(error: error)
                    }
                }
            case .failure(let error):
                self.presentAlert(error: error)
            }
        }
        
        return cell
        
    }

}

extension MainController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let name = self.pokemonFetches[indexPath.row].name
        guard let pokemon = self.pokemonFetched[name] else {return}
        let detail = Details(pokemon: pokemon)
        self.navigationController?.pushViewController(detail, animated: true)
    }
}

extension MainController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastCellIndexPath = IndexPath(row: self.pokemonFetches.count - 1, section: 0)
        guard self.pokemonFetches.count < 151 - self.limit && indexPaths.contains(lastCellIndexPath) else { return }
        self.fetchPokemonList(url: self.nextPage)
    }
}
