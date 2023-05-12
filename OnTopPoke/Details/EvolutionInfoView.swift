//
//  EvolutionInfoView.swift
//  OnTopPoke
//
//  Created by Lucas Farah on 12/05/23.
//

import UIKit

enum EvolutionType {
    case current
    case devolution
    case evolution
}

final class EvolutionInfoView: UIView {

    let nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title3)
        view.textAlignment = .center
        view.textColor = .darkText
        view.minimumScaleFactor = 0.1
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    let pokemonImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
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
        layer.cornerRadius = 16
        clipsToBounds = true
        
        addSubview(nameLabel)
        addSubview(pokemonImageView)

        NSLayoutConstraint.activate([
            
            pokemonImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pokemonImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: topAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: pokemonImageView.bottomAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    func configure(with species: Species, type: EvolutionType) {
        nameLabel.text = species.name
        pokemonImageView.kf.setImage(with: species.imageURL, placeholder: UIImage(named: "PlaceholderImage"))
        
        switch type {
        case .current:
            backgroundColor = .systemYellow
            alpha = 1
        case .devolution:
            backgroundColor = .clear
            alpha = 0.5
        case .evolution:
            backgroundColor = .clear
            alpha = 1
        }
    }
}
