//
//  Pokemon.swift
//  PokemonBlue
//
//  Created by Field Employee on 7/31/20.
//  Copyright © 2020 JediWattson. All rights reserved.
//

import UIKit

struct PokemonList: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [NameLink]
    
    enum codingKeys: String, CodingKey {
        case count, next, previous, results
    }
}

struct Pokemon: Codable {
    var id: Int
    var name: String
    var weight: Int
    var height: Int
    var order: Int
    var baseExperience: Int
    var image: UIImage?
    var locationAreaEncounters: String
    var isDefault: Bool
    var abilities: [Ability]
    var forms: [NameLink]
    var moves: [Move]
    var species: NameLink
    var sprites: Sprites
    var stats: [Stats]
    var types: [Types]
    var gameIndices: [GameIndices]
    
    enum CodingKeys: String, CodingKey {
        case id, name, weight, height, order, abilities, forms, moves, species, sprites, stats, types
        case baseExperience = "base_experience"
        case locationAreaEncounters = "location_area_encounters"
        case isDefault = "is_default"
        case gameIndices = "game_indices"
    }
}

struct Sprites: Codable {
    var backDefault: String?
    var backFemale: String?
    var backShiny: String?
    var backShinyFemale: String?
    var frontDefault: String?
    var frontFemale: String?
    var frontShiny: String?
    var frontShinyFemale: String?
    
    enum CodingKeys: String, CodingKey {
        case backDefault = "back_default"
        case backFemale = "back_female"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        
    }
}

struct Types: Codable {
    var slot: Int
    var type: NameLink
}

struct Stats: Codable {
    var baseEffort: Int?
    var effort: Int
    var stat: NameLink
    
    enum CodingKeys: String, CodingKey {
        case effort, stat
        case baseEffort = "base_effort"
    }
}

struct Ability: Codable {
    var slot: Int
    var isHidden: Bool
    var ability: NameLink
    
    enum CodingKeys: String, CodingKey {
        case slot, ability
        case isHidden = "is_hidden"
    }
}

struct GameIndices: Codable {
    var gameIndex: Int
    var version: NameLink
    
    enum CodingKeys: String, CodingKey {
        case version
        case gameIndex = "game_index"
    }
}

struct Move: Codable {
    var move: NameLink
    var versionGroupDetails: [VersionGroupDetails]
    
    enum CodingKeys: String, CodingKey {
        case move
        case versionGroupDetails = "version_group_details"
    }
}

struct VersionGroupDetails: Codable {
    var levelLearnedAt: Int
    var moveLearnMethod: NameLink
    var versionGroup: NameLink
    
    enum CodingKeys: String, CodingKey{
        case levelLearnedAt = "level_learned_at"
        case moveLearnMethod = "move_learn_method"
        case versionGroup = "version_group"
    }
}

struct NameLink: Codable {
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey{
        case name, url
    }
}
