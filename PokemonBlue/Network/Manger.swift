//
//  File.swift
//  PokemonBlue
//
//  Created by Field Employee on 7/31/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import UIKit
import Alamofire

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
        AF.request(url).validate().responseDecodable(of: PokemonList.self ){ response in
            guard let list = response.value else {
                guard let errorString = response.error?.localizedDescription else {return}
                completion(.failure(.serverError(errorString)))
                return
            }
            completion(.success(list))
        }
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
    
    func fetchPokemon(_ url: String, completion: @escaping PokemonTrainer) {
        if let data = cache.get(url: url){
            self.decodePokemon(data: data, completion: completion)
            return
        }
        AF.request(url).validate().responseDecodable(of: Pokemon.self ){ response in
            guard var pokemon = response.value else {
                guard let errorString = response.error?.localizedDescription else {return}
                completion(.failure(.serverError(errorString)))
                return
            }
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

        }
        
    }
    
    func setImage(data: Data, completion: @escaping imgHandler){
        guard let image = UIImage(data: data) else {
            completion(.failure(.badImage))
            return
        }
        completion(.success(image))
    }
    
    func fetchSprite(_ url: String, completion: @escaping imgHandler) {
        
        if let data = cache.get(url: url) {
            self.setImage(data: data, completion: completion)
            return
        }
        
        AF.request(url).validate().response{
            response in
            if let err = response.error {
                completion(.failure(.serverError(err.localizedDescription)))
                return
            }
            guard let data = response.data else {
                completion(.failure(.badData))
                return
            }
            self.cache.set(data: data, url: url)
            self.setImage(data: data, completion: completion)
        }
    }
}

