//
//  UserListViewController.swift
//  MyNetwork
//
//  Created by Guillermo on 20/05/23.
//

import UIKit

class UserListViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchUserTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: UserListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")

        headerView.addShadow()
        searchUserTextField.setBottomBorder(borderColor: UIColor(named: "main_green"))
    }
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // TODO: Replace with real data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell") as! UserTableViewCell
        return cell
    }
}
