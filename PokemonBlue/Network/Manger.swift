//
//  File.swift
//  PokemonBlue
//
//  Created by Field Employee on 7/31/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import UIKit

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
    func fetchPokemonList(_ url: String, completion: @escaping (PokemonList?) -> ()){
        guard let url = URL(string: url) else { return }
        self.session.dataTask(with: url) { (data, res, err) in
                
            guard
                err == nil,
                let data = data
            else {
               completion(nil)
               return
            }

            do {
                let list = try self.decoder.decode(PokemonList.self, from: data)
                completion(list)
            } catch {
                print(error)
            }
            completion(nil)
        }.resume()
        
    }
    
    func fetchPokemon(_ url: String, completion: @escaping (Pokemon?) -> ()) {
        guard let url = URL(string: url) else { return }
        self.session.dataTask(with: url) { (data, res, err) in
               
            guard
                err == nil,
                let data = data
            else {
                completion(nil)
                return
            }

            do {
                let pokemon = try self.decoder.decode(Pokemon.self, from: data)
                completion(pokemon)
            } catch {
                print(error)
            }
            
            completion(nil)
        }.resume()
    }
    
    func fetchSprite(_ url: String, completion: @escaping (UIImage?)->()) {
        guard let url = URL(string: url) else { return }
        self.session.dataTask(with: url) { (data, res, err) in
            guard
                err == nil,
                let data = data,
                let image = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
}
