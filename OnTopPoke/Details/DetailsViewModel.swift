//
//  DetailsViewModel.swift
//  OnTopPoke
//
//  Created by Lucas Farah on 13/05/23.
//

import Foundation

class DetailsViewModel {
    let species: Species
    let requestHandler: RequestHandling
    
    var speciesDetails: SpeciesDetails?
    
    var updatedDescription: ((_ description: String?) -> Void)?
    var updatedEvolutionChain: ((_ chain: (Species, Species?, Species?), _ currentSpecies: Species) -> Void)?
    
    init(species: Species,
         requestHandler: RequestHandling = RequestHandler()) {
        self.requestHandler = requestHandler
        self.species = species
        
        loadDetails { [weak self] in
            self?.updatedDescription?(self?.speciesDetails?.flavorTextEntries.filter { $0.language.name == "en" }.first?.flavorText)
            self?.loadEvolution { details in
                guard let self = self else { return }
                self.updatedEvolutionChain?(self.parseEvolution(chain: details), self.species)
            }
        }
    }
    
    private func loadDetails(handler: @escaping () -> Void) {
        // TODO fetch details using your request handler, using the APIRouter endpoints
        do {
            try requestHandler.request(route: .getSpecies(species.url)) { [weak self] (result: Result<SpeciesDetails, Error>) -> Void in
                switch result {
                case .success(let details):
                    self?.speciesDetails = details
                    print("details: \(details)")
                case .failure(let error):
                    // TODO: Error handling
                    print("error: \(error)")
                }
                handler()
            }
        } catch {
            // TODO: handle request handling failures failures
            print("TODO handle request handling failures failures")
        }
    }
    
    private func loadEvolution(handler: @escaping (_ details: EvolutionChainDetails) -> Void) {
        guard let details = speciesDetails else {
            return
        }
        
        do {
            try requestHandler.request(route: .getEvolutionChain(details.evolutionChain.url)) { (result: Result<EvolutionChainDetails, Error>) -> Void in
                switch result {
                case .success(let details):
                    print("details: \(details)")
                    handler(details)
                case .failure(let error):
                    // TODO: Error handling
                    print("error: \(error)")
                }
            }
        } catch {
            // TODO: handle request handling failures failures
            print("TODO handle request handling failures failures")
        }
    }
    
    func parseEvolution(chain: EvolutionChainDetails) -> (Species, Species?, Species?) {
        
        let firstChain = chain.chain
        let secondChain = firstChain.evolvesTo.first
        let thirdChain = secondChain?.evolvesTo.first

        return (firstChain.species, secondChain?.species, thirdChain?.species)
    }
}
