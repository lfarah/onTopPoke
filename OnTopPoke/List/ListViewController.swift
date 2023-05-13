import UIKit
import Kingfisher

public final class ListViewController: UIViewController {
    
    private let viewModel: ListViewModel
    
    public var showDetails: ((_ species: Species) -> Void)?
    
    public init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(type: ListCell.self)
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refreshData), for: .valueChanged)
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

    @objc private func refreshData() {
        refreshControl.beginRefreshing()
        viewModel.refreshData()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "POKéMON"

        setupViews()
        viewModel.fetchSpecies()
        
        viewModel.reloadData = { [weak self] in
            self?.errorLabel.isHidden = true
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
        
        viewModel.showError = { [weak self] error in
            self?.errorLabel.text = error.localizedDescription
            self?.errorLabel.isHidden = false
        }
    }

    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(errorLabel)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.species.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ListCell.self, indexPath: indexPath)
        cell.configure(with: viewModel.species[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        showDetails?(viewModel.species[indexPath.row])
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height - 200,
            !refreshControl.isRefreshing,
            contentHeight > 0 {
                viewModel.loadNextPage()
        }
    }
}
