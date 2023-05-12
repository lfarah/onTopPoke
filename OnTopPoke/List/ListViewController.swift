import UIKit
import Kingfisher

/// Main view showing the list of Pokémon
///
/// The tableview is setup already. but fetching from a fake request handler, returning fake Pokémon, and showing a local image
/// Goal:
/// - Use your own `RequestHandler` to fetch Pokémon from the backend
/// - Display the pokemon name and image (fetched remotely)
/// - Implement pagination to simulate infinite scrolling
/// - Error handling
///
/// Not required, but feel free to improve/reorganize the ViewController however you like.
class ListViewController: UIViewController {
    /// TODO, replace with your own `RequestHandler`
    private let requestHandler: RequestHandling = RequestHandler()

    private var species: [Species] = []

    private var isLoading = false
    private let itemsPerPage = 20
    private var pageNumber = 0

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(type: ListCell.self)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "POKéMON"

        setupViews()
        fetchSpecies()
    }

    private func setupViews() {
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func fetchSpecies() {
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
                case .failure:
                    print("TODO handle network failures")
                }
                self?.isLoading = false
            }
        } catch {
            print("TODO handle request handling failures failures")
        }
    }

    private func didFetchSpecies(response: SpeciesResponse) {
        species += response.results
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return species.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(type: ListCell.self, indexPath: indexPath)
        cell.configure(with: species[indexPath.row])
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let viewController = DetailsViewController(species: species[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.size.height {
            pageNumber += 1
            fetchSpecies()
        }
    }
}
