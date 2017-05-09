//
//  EditInvitedFriendsCollectionViewCell.swift
//  BallClub
//
//  Created by Joshua Relova on 5/9/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit
import Nuke

class EditInvitedFriendsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUserName (userName: String) {
        userNameLabel.text = "Josh"
    }

    func setImageOfFriend(imageUrlString : String) {
        if let imageUrl = URL(string: imageUrlString) {
            Nuke.loadImage(with: imageUrl, into: userImageView)
        }
    }
}
