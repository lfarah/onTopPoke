//
//  ListViewModel.swift
//  OnTopPoke
//
//  Created by Lucas Farah on 12/05/23.
//

import Foundation

class ListViewModel {
    let requestHandler: RequestHandling
    
    var species: [Species] = []
    
    private var isLoading = false
    private let itemsPerPage = 20
    private var pageNumber = 0
    var reloadData: (() -> Void)?
    var showError: ((_ error: Error) -> Void)?
    
    init(requestHandler: RequestHandling = RequestHandler()) {
        self.requestHandler = requestHandler
    }
    
    func fetchSpecies() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        do {
            // TODO Consider pagination
            try requestHandler.request(route: .getSpeciesList(limit: itemsPerPage, offset: pageNumber * self.itemsPerPage)) { [weak self] (result: Result<SpeciesResponse, Error>) -> Void in
                switch result {
                case .success(let response):
                    self?.didFetchSpecies(response: response)
                case .failure(let error):
                    self?.showError?(error)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self?.isLoading = false
                })
            }
        } catch let error {
            showError?(error)
        }
    }
    
    private func didFetchSpecies(response: SpeciesResponse) {
        species += response.results
        reloadData?()
    }
    
    func loadNextPage() {
        pageNumber += 1
        fetchSpecies()
    }
    
    @objc func refreshData() {
        species = []
        pageNumber = 0
        reloadData?()
        fetchSpecies()
    }
}
