import UIKit
import Kingfisher

/// Details view showing the evolution chain of a Pokémon (WIP)
///
/// It now only shows a placeholder image, make it so that it also shows the evolution chain of the selected Pokémon, in whatever way you think works best.
/// The evolution chain url can be fetched using the endpoint `APIRouter.getSpecies(URL)` (returns type `SpeciesDetails`), and the evolution chain details through `APIRouter.getEvolutionChain(URL)` (returns type `EvolutionChainDetails`).
/// Requires a working `RequestHandler`
class DetailsViewController: UIViewController {
    
    let viewModel: DetailsViewModel
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "PlaceholderImage")
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title3)
        view.numberOfLines = 0
        return view
    }()
    
    let evolutionTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title2)
        view.numberOfLines = 1
        view.text = "Evolution Chain"
        return view
    }()
    
    let evolutionStack: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalCentering
        return view
    }()
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = viewModel.species.name
        
        setupViews()
        
        viewModel.updatedDescription = { [weak self] description in
            self?.descriptionLabel.text = description
        }
        
        viewModel.updatedEvolutionChain = { [weak self] chain in
            self?.setupEvolution(with: chain)
        }
    }
    
    private func setupViews() {
        // TODO Feel free to set up the screen any way you like
        imageView.kf.setImage(with: viewModel.species.imageURL, placeholder: UIImage(named: "PlaceholderImage"))
        
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        view.addSubview(evolutionTitleLabel)
        view.addSubview(evolutionStack)
        
        NSLayoutConstraint.activate([
            
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 150),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            
            evolutionTitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 32),
            evolutionTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            evolutionTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            evolutionStack.topAnchor.constraint(equalTo: evolutionTitleLabel.bottomAnchor, constant: 8),
            evolutionStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            evolutionStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])
    }
    
    // TODO: Refactor into smaller views
    func setupEvolution(with evolutions: (Species, Species?, Species?)) {
        
        let isFirstPokemonSelected = evolutions.0.url == viewModel.species.url
        let isSecondPokemonSelected = evolutions.1?.url == viewModel.species.url as URL?
        let isThirdPokemonSelected = evolutions.2?.url == viewModel.species.url as URL?
        
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
