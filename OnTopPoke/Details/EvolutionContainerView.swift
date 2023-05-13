//
//  EvolutionContainerView.swift
//  OnTopPoke
//
//  Created by Lucas Farah on 13/05/23.
//

import UIKit

public final class EvolutionContainerView: UIView {

    private let evolutionStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalCentering
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(evolutionStack)
        
        NSLayoutConstraint.activate([
            evolutionStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            evolutionStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            evolutionStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    public func setupEvolution(with evolutions: (Species, Species?, Species?), currentSpecies: Species) {
        evolutionStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let isFirstPokemonSelected = evolutions.0.url == currentSpecies.url
        let isSecondPokemonSelected = evolutions.1?.url == currentSpecies.url as URL?
        let isThirdPokemonSelected = evolutions.2?.url == currentSpecies.url as URL?
        
        let firstEvolutionView = EvolutionInfoView(frame: .zero)
        firstEvolutionView.configure(with: evolutions.0, type: isFirstPokemonSelected ? .current : .devolution)
        evolutionStack.addArrangedSubview(firstEvolutionView)
        
        if let pokemon = evolutions.1 {
            let secondEvolutionView = EvolutionInfoView(frame: .zero)
            secondEvolutionView.configure(with: pokemon, type: isSecondPokemonSelected ? .current : isThirdPokemonSelected ? .devolution : .evolution)
            
            let arrowIcon = UIImageView(frame: .zero)
            arrowIcon.translatesAutoresizingMaskIntoConstraints = false
            arrowIcon.image = UIImage(systemName: "arrow.forward")
            arrowIcon.contentMode = .scaleAspectFit
            
            evolutionStack.addArrangedSubview(arrowIcon)
            evolutionStack.addArrangedSubview(secondEvolutionView)
        }
        
        if let pokemon = evolutions.2 {
            let thirdEvolutionView = EvolutionInfoView(frame: .zero)
            thirdEvolutionView.configure(with: pokemon, type: isThirdPokemonSelected ? .current : .evolution)
            
            let arrowIcon = UIImageView(frame: .zero)
            arrowIcon.translatesAutoresizingMaskIntoConstraints = false
            arrowIcon.image = UIImage(systemName: "arrow.forward")
            arrowIcon.contentMode = .scaleAspectFit
            
            evolutionStack.addArrangedSubview(arrowIcon)
            evolutionStack.addArrangedSubview(thirdEvolutionView)
        }
    }
}
