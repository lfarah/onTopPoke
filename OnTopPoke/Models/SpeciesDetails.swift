import Foundation

/// Species object returned as part of the `getSpeciesDetails` endpoint
struct SpeciesDetails: Codable {
    let name: String
    let evolutionChain: EvolutionChain
    let flavorTextEntries: [TextEntry]
}

/// EvolutionChain model returned as part of the SpeciesDetails from the `getSpecies` endpoint
struct EvolutionChain: Codable {
    let url: URL
}

struct TextEntry: Codable {
    let flavorText: String
    let language: TextEntryLanguage
}

struct TextEntryLanguage: Codable {
    let name: String
}
