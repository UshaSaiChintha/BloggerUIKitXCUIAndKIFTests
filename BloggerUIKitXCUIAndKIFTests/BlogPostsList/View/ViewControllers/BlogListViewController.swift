//
//  BlogListViewController.swift
//  BloggerUIKitXCUIAndKIFTests
//
//  Created by Usha Sai Chintha on 01/05/23.
//

import UIKit
import Combine
import Factory

class BlogListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @LazyInjected(\.blogListViewModel) private var viewModel: BlogListViewModel
    
    private let identifier = String(describing: BlogPostTableViewCell.self)
    private var cancelBag = Set<AnyCancellable>()
    private var blogPosts = [BlogPost]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        fetchBlogPosts()
        tableView.accessibilityIdentifier = "blogPostTableView"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        let selectedBlog = self.blogPosts[indexPath.row]
        let destination = segue.destination as! BlogDetailViewController
        destination.blog = selectedBlog
    }
    
    private func fetchBlogPosts() {
        self.viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { currentState in
            switch currentState {
            case .idle:
                self.viewModel.fetchBlogPosts()
            case .loading:
                print("loading")
            case .error( _):
                self.blogPosts = []
                let errorLabel = UILabel()
                errorLabel.accessibilityIdentifier = "errorLabel"
                errorLabel.text = "Something went wrong try again."
                self.tableView.backgroundView = errorLabel
            case .success(let data):
                self.blogPosts = data
            }
        }
        .store(in: &cancelBag)
    }
}

extension BlogListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let blogPost = self.blogPosts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = blogPost.title
        content.secondaryText = blogPost.body
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.blogPosts.count
    }
}

extension BlogListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "BlogDetailViewController", sender: nil)
    }
}
