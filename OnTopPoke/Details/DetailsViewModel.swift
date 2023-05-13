//
//  DetailsViewModel.swift
//  OnTopPoke
//
//  Created by Lucas Farah on 13/05/23.
//

import Foundation

public final class DetailsViewModel {
    public let species: Species
    private let requestHandler: RequestHandling
    
    public var speciesDetails: SpeciesDetails?
    
    public var updatedDescription: ((_ description: String?) -> Void)?
    public var updatedEvolutionChain: ((_ chain: (Species, Species?, Species?), _ currentSpecies: Species) -> Void)?
    public var showError: ((_ error: Error) -> Void)?

    init(species: Species,
         requestHandler: RequestHandling = RequestHandler()) {
        self.requestHandler = requestHandler
        self.species = species
        
    }
    
    func load() {
        loadDetails { [weak self] in
            self?.updatedDescription?(self?.speciesDetails?.flavorTextEntries.filter { $0.language.name == "en" }.first?.flavorText)
            self?.loadEvolution { details in
                guard let self = self else { return }
                self.updatedEvolutionChain?(self.parseEvolution(chain: details), self.species)
            }
        }
    }
    
    private func loadDetails(handler: @escaping () -> Void) {
        do {
            try requestHandler.request(route: .getSpecies(species.url)) { [weak self] (result: Result<SpeciesDetails, Error>) -> Void in
                switch result {
                case .success(let details):
                    self?.speciesDetails = details
                case .failure(let error):
                    self?.showError?(error)
                }
                handler()
            }
        } catch let error {
            showError?(error)
        }
    }
    
    private func loadEvolution(handler: @escaping (_ details: EvolutionChainDetails) -> Void) {
        guard let details = speciesDetails else {
            return
        }
        
        do {
            try requestHandler.request(route: .getEvolutionChain(details.evolutionChain.url)) { [weak self] (result: Result<EvolutionChainDetails, Error>) -> Void in
                switch result {
                case .success(let details):
                    handler(details)
                case .failure(let error):
                    self?.showError?(error)
                }
            }
        } catch let error {
            showError?(error)
        }
    }
    
    private func parseEvolution(chain: EvolutionChainDetails) -> (Species, Species?, Species?) {
        
        let firstChain = chain.chain
        let secondChain = firstChain.evolvesTo.first
        let thirdChain = secondChain?.evolvesTo.first

        return (firstChain.species, secondChain?.species, thirdChain?.species)
    }
}
