import SafariServices
import UIKit

final class NewsTableViewController: UITableViewController {
    // MARK: - Properties
    
    // MARK: Private
    
    private var news: [NewsStory] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addSetups()
        fetchNews()
    }
    
    // MARK: - Networking
    
    private func fetchNews() {
        NetworkingManager.instance.getNews { [weak self] result in
            self?.news = result
        }
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {}
    
    private func addSetups() {
        // addNavigationSetups()
        addTableViewSetups()
        addTableHeaderView()
    }
    
    private func addNavigationSetups() {
        title = "Business News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func addTableViewSetups() {
        tableView.backgroundColor = .theme.background
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func addTableHeaderView() {
        let titleView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 250,
                height: 70))
        let label = UILabel(
            frame: CGRect(
                x: 10,
                y: 0,
                width: titleView.frame.width - 20,
                height: titleView.frame.height))
        titleView.addSubview(label)
        label.text = "Bussines News"
        label.font = .altone(30, .bold)
        tableView.tableHeaderView = titleView
    }
    
    // MARK: - Helpers
    
    // MARK: Private
    
    private func presentFailedOpenAlert() {
        let alert = UIAlertController(
            title: "Unable to Open",
            message: "We were unable to open the article",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    private func open(url: URL) {
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell {
            let news = news[indexPath.row]
            cell.set(news.image, news.headline, news.source, .string(from: news.datetime))
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = news[indexPath.row]
        guard let url = URL(string: story.url) else {
            presentFailedOpenAlert()
            return
        }
        open(url: url)
    }
}
