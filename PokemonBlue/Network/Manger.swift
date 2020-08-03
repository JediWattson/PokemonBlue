//
//  File.swift
//  PokemonBlue
//
//  Created by Field Employee on 7/31/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import UIKit

typealias ListHandler = (Result<PokemonList, NetworkError>) -> ()
typealias imgHandler = (Result<UIImage, NetworkError>) -> ()
typealias PokemonTrainer = (Result<Pokemon, NetworkError>) -> ()

class NetworkManager {
    static let shared = NetworkManager()
    var session: URLSession
    var decoder: JSONDecoder
    var cache: NetworkCache
    
    private init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder(), cache: NetworkCache = NetworkCache.shared){
        self.session = session
        self.decoder = decoder
        self.cache = cache
    }
}

extension NetworkManager {
    func fetchPokemonList(_ url: String, completion: @escaping ListHandler){
        guard let url = URL(string: url) else {
            completion(.failure(.badURL))
            return
        }
        self.session.dataTask(with: url) { (data, res, err) in
            if let err = err {
                completion(.failure(.serverError(err.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
               return
            }

            do {
                let list = try self.decoder.decode(PokemonList.self, from: data)
                completion(.success(list))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
        
    }
    
    func decodePokemon(data: Data, completion: @escaping PokemonTrainer){
        do {
            var pokemon = try self.decoder.decode(Pokemon.self, from: data)
            guard let imageURL = pokemon.sprites.frontDefault else {
                completion(.failure(.badURL))
                return
            }
            self.fetchSprite(imageURL){result in
                switch result {
                case .success(let image):
                    pokemon.image = image
                    completion(.success(pokemon))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.decodeError))
        }
    }
    
    func fetchPokemon(_ pokemonURL: String, completion: @escaping PokemonTrainer) {
        if let data = cache.get(url: pokemonURL){
            self.decodePokemon(data: data, completion: completion)
            return
        }
        
        guard let url = URL(string: pokemonURL) else {
            completion(.failure(.badURL))
            return
        }
        
        self.session.dataTask(with: url) { (data, res, err) in
            if let err = err {
                completion(.failure(.serverError(err.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
               return
            }
            self.cache.set(data: data, url: pokemonURL)
            self.decodePokemon(data: data, completion: completion)
        }.resume()
    }
    
    func setImage(data: Data, completion: @escaping imgHandler){
        guard let image = UIImage(data: data) else {
            completion(.failure(.badImage))
            return
        }
        completion(.success(image))
    }
    
    func fetchSprite(_ imgURL: String, completion: @escaping imgHandler) {
        
        if let data = cache.get(url: imgURL) {
            self.setImage(data: data, completion: completion)
            return
        }
        
        guard let url = URL(string: imgURL) else {
            completion(.failure(.badURL))
            return
        }
        
        self.session.dataTask(with: url) { (data, res, err) in
            
            if let err = err {
                completion(.failure(.serverError(err.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData))
               return
            }
            
            self.cache.set(data: data, url: imgURL)
            self.setImage(data: data, completion: completion)
        }.resume()
    }
    
}
