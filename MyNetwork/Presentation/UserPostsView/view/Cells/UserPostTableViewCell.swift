//
//  UserPostTableViewCell.swift
//  MyNetwork
//
//  Created by Guillermo on 21/05/23.
//

import UIKit



class UserPostTableViewCell: UITableViewCell {

    static let identifier = "UserPostTableViewCell"

    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postBodyLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUp(post: UserPostDisplayModel){
        postTitleLabel.text = post.title
        postBodyLabel.text = post.body
    }
    
}
