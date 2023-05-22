//
//  UserPostsViewController.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import UIKit
import Combine

class UserPostsViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: UserPostsViewModel!
    var posts: [UserPostDisplayModel] = []
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: UserPostTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: UserPostTableViewCell.identifier)
        bind()
        viewModel.fetchPosts()
    }

    func bind(){
        let fetchedPosts = viewModel.$posts
        let loading = viewModel.$loading

        fetchedPosts
            .sink { [weak self] posts in
                self?.posts = posts
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        loading
            .sink{[weak self] isLoading in
                self?.showHideLoadingView(isLoading)
            }.store(in: &cancellables)
    }

    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

}

extension UserPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserPostTableViewCell.identifier, for: indexPath) as! UserPostTableViewCell
        cell.setUp(post: posts[indexPath.row])
        return cell
    }
}
