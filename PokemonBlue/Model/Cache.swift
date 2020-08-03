//
//  Cache.swift
//  PokemonBlue
//
//  Created by Field Employee on 8/3/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import Foundation

class NetworkCache {
    static var shared = NetworkCache()
    
    private let cache: NSCache<NSString, NSData>
    
    private init (cache: NSCache<NSString, NSData> = NSCache<NSString, NSData>()){
        self.cache = cache
    }
}


extension NetworkCache {
    func set (data: Data, url: String){
        let key = NSString(string: url)
        let object = NSData(data: data)
        self.cache.setObject(object, forKey: key)
    }
    func get(url: String) -> Data? {
        let key = NSString(string: url)
        guard let object = self.cache.object(forKey: key) else {return nil}
        return Data(referencing: object)
    }
}
