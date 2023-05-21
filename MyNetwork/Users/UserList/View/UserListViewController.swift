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
    
    var viewModel: UserListViewModel!
    var users: [UserDisplayModel] = []
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")

        headerView.addShadow()
        searchUserTextField.setBottomBorder(borderColor: UIColor(named: "main_green"))
        bind()
        viewModel.fetchUsers()
    }
    
    func bind(){
        viewModel.$users
            .sink { [weak self] users in
                self?.users = users
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        cell.setUp(user: users[indexPath.row])
        return cell
    }
}
