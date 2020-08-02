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
    
    private init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()){
        self.session = session
        self.decoder = decoder
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
    
    func fetchPokemon(_ url: String, completion: @escaping PokemonTrainer) {
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
                let pokemon = try self.decoder.decode(Pokemon.self, from: data)
                completion(.success(pokemon))
            } catch {
                completion(.failure(.decodeError))
            }
        }.resume()
    }
    
    func fetchSprite(_ url: String, completion: @escaping imgHandler) {
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
            guard let image = UIImage(data: data) else {
                completion(.failure(.badImage))
                return
            }
            completion(.success(image))
            
        }.resume()
    }
    
}
