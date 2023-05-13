import Foundation

/// Species object returned as part of the `getSpeciesDetails` endpoint
public struct SpeciesDetails: Codable {
    let name: String
    let evolutionChain: EvolutionChain
    let flavorTextEntries: [TextEntry]
}

/// EvolutionChain model returned as part of the SpeciesDetails from the `getSpecies` endpoint
public struct EvolutionChain: Codable {
    let url: URL
}

public struct TextEntry: Codable {
    let flavorText: String
    let language: TextEntryLanguage
}

public struct TextEntryLanguage: Codable {
    let name: String
}
