//
//  SpeciesTests.swift
//  OnTopPokeTests
//
//  Created by Lucas Farah on 13/05/23.
//

import XCTest
@testable import OnTopPoke

final class SpeciesTests: XCTestCase {

    func testImageURLParsesCorrectly() throws {
        let species = Species(name: "charizard", url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/6/")!)
        XCTAssertEqual(species.imageURL?.absoluteString, "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/6.png")
    }
    
    func testImageURLParsesCorrectlyReturnsNil() throws {
        let species = Species(name: "charizard", url: URL(string: "https://pokeapi.co/api/v2/pokemon-species/")!)
        XCTAssertNil(species.imageURL)
    }
}
