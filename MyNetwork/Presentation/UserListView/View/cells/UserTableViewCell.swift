//
//  UserTableViewCell.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import UIKit

protocol UserTableViewCellDelegate: AnyObject {
    func didTapShowPosts(by user: UserDisplayModel)
}

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    
    var user: UserDisplayModel?
    weak var delegate: UserTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.addShadow()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(user: UserDisplayModel){
        userNameLabel.text = user.name
        phoneLabel.text = user.phone
        emailLabel.text = user.email
        self.user = user
    }
    
    @IBAction func didTapSeePosts(_ sender: Any) {
        guard let user = user else {return}
        delegate?.didTapShowPosts(by: user)
    }
}
