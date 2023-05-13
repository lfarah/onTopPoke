import Foundation

/// Response from the `getSpeciesList` endpoint
struct SpeciesResponse: Codable {
    let count: Int
    let results: [Species]
}

/// Species object returned as part of the `SpeciesResponse` object from the `getSpeciesList` endpoint
public struct Species: Codable {
    let name: String
    let url: URL
    
    // TODO: Write tests
    var imageURL: URL? {
        let components = url.absoluteString.components(separatedBy: "/")
        let id = components[components.count - 2]
        if let id = Int(id) {
            return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
        } else {
            return nil
        }
    }
}
