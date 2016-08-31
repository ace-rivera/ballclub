//
//  LoginViewController.swift
//  BallClub
//
//  Created by Geraldine Forto on 30/08/2016.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var forgotDetailsButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailAddLabel: UITextField!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var appLogo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.hidden = true
        loginButton.layer.borderColor = UIColor.lightGrayColor().CGColor
        loginButton.layer.borderWidth = 1
        
        emailAddLabel.attributedPlaceholder = NSAttributedString(string:"E-mail",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        passwordLabel.attributedPlaceholder = NSAttributedString(string:"Password",
                                                                 attributes:[NSForegroundColorAttributeName: UIColor.lightGrayColor()])
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
