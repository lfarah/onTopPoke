import UIKit
import Kingfisher

class ListCell: UITableViewCell {
    static let reuseIdentifier = "ListCell"
    
    let nameLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title3)
        return view
    }()
    
    let pokemonImageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(pokemonImageView)

        NSLayoutConstraint.activate([
            
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: pokemonImageView.trailingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with species: Species) {
        nameLabel.text = species.name
        pokemonImageView.kf.setImage(with: species.imageURL, placeholder: UIImage(named: "PlaceholderImage"))
    }
}
