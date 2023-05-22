//
//  UserListViewController.swift
//  MyNetwork
//
//  Created by Guillermo on 20/05/23.
//

import UIKit
import Combine

class UserListViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchUserTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyListMessage: UIView!
    
    var viewModel: UserListViewModel!
    var users: [UserDisplayModel] = []
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        searchUserTextField.delegate = self

        headerView.addShadow()
        searchUserTextField.setBottomBorder(borderColor: UIColor(named: "main_green"))
        bind()
        viewModel.fetchUsersFromCacheOrService()
    }
    
    func bind(){
        let fetchedUsers = viewModel.$users
        let didFinishFirstRequest = viewModel.$isFirstFetchCompleted
        let loading = viewModel.$loading
        
        fetchedUsers
            .sink { [weak self] users in
                self?.users = users
                self?.tableView.reloadData()
                self?.updateEmptyListMessage()
                
            }
            .store(in: &cancellables)
        
        didFinishFirstRequest
            .sink{ [weak self] didFinish in
                self?.updateTextFieldInteraction(didFinish)
            }.store(in: &cancellables)
        
        loading
            .sink{[weak self] isLoading in
                self?.showHideLoadingView(isLoading)
            }.store(in: &cancellables)
        
    }
    
    func updateEmptyListMessage(){
        emptyListMessage.isHidden = users.isEmpty ? false : true
    }
    
    func updateTextFieldInteraction(_ isFirstFetchCompleted: Bool) {
        searchUserTextField.isUserInteractionEnabled = isFirstFetchCompleted
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        cell.delegate = self
        cell.setUp(user: users[indexPath.row])
        return cell
    }
}

extension UserListViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        viewModel.filterUsers(by: searchText)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UserListViewController: UserTableViewCellDelegate {
    func didTapShowPosts(by user: UserDisplayModel) {
        let userPostsViewBuilder = UserPostsViewControllerBuilder()
        let postsVC = userPostsViewBuilder.build(user: user)
        guard let navigationController = self.navigationController else {return}
        self.navigationController?.pushViewController(postsVC, animated: true)
    }
    
    
}
