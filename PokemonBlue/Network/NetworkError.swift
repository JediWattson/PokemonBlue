//
//  NetworkError.swift
//  PokemonBlue
//
//  Created by Field Employee on 8/2/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case serverError(String)
    case badData
    case decodeError
    case badImage
}

extension NetworkError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .badURL:
            return NSLocalizedString("Bad URL, could not convert string to URL", comment: "Bad URL")
        case .badData:
            return NSLocalizedString("Bad data, the data was corrupted or incorrect", comment: "Bad Data")
        case .serverError(let description):
            return NSLocalizedString(description, comment: "Server Error")
        case .decodeError:
            return NSLocalizedString("Decoding Failure, the data could not be decoded to the model", comment: "Decode Failure")
        case .badImage:
            return NSLocalizedString("The data recieved was not in the correct image format", comment: "Corrupt Image File")
        }
    }
}
