import UIKit
import Kingfisher

public final class DetailsViewController: UIViewController {
    
    private let viewModel: DetailsViewModel
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "PlaceholderImage")
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title3)
        view.numberOfLines = 0
        return view
    }()
    
    private let evolutionTitleLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title2)
        view.numberOfLines = 1
        view.text = "Evolution Chain"
        return view
    }()
    
    private let errorLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title1)
        view.textColor = UIColor.systemRed
        view.isHidden = true
        view.numberOfLines = 0
        view.backgroundColor = .white
        return view
    }()
    
    private let evolutionContainer: EvolutionContainerView = {
        let view = EvolutionContainerView(frame: .zero)
        return view
    }()
    
    public init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = viewModel.species.name
        
        setupViews()
        
        viewModel.updatedDescription = { [weak self] description in
            self?.descriptionLabel.text = description
        }
        
        viewModel.updatedEvolutionChain = { [weak self] chain, currentSpecies in
            self?.evolutionContainer.setupEvolution(with: chain, currentSpecies: currentSpecies)
        }
        
        viewModel.showError = { [weak self] error in
            self?.errorLabel.text = error.localizedDescription
            self?.errorLabel.isHidden = false
        }
        
        viewModel.load()
    }
    
    private func setupViews() {
        imageView.kf.setImage(with: viewModel.species.imageURL, placeholder: UIImage(named: "PlaceholderImage"))
        
        view.addSubview(imageView)
        view.addSubview(descriptionLabel)
        view.addSubview(evolutionTitleLabel)
        view.addSubview(evolutionContainer)
        view.addSubview(errorLabel)

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
            
            evolutionContainer.topAnchor.constraint(equalTo: evolutionTitleLabel.bottomAnchor, constant: 8),
            evolutionContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            evolutionContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            errorLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
