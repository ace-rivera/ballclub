//
//  CreateProfileTableViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 8/31/16.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit

class CreateProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var aboutMeTextField: MKTextField!
    @IBOutlet weak var favoriteTeamTextField: MKTextField!
    @IBOutlet weak var favoritePlayerTextField: MKTextField!
    @IBOutlet weak var sexTextField: MKTextField!
    @IBOutlet weak var weightTextField: MKTextField!
    @IBOutlet weak var birthDateTextField: MKTextField!
    @IBOutlet weak var heightTextField: MKTextField!
    @IBOutlet weak var homeCityTextField: MKTextField!
    @IBOutlet weak var lastNameTextField: MKTextField!
    @IBOutlet weak var firstNameTextField: MKTextField!
    @IBOutlet weak var centerButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var guardButton: UIButton!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    
    private var imagePicker :  UIImagePickerController!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        
        setupUi()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK:- SetupUI
    func setupUi(){
        guardButton.isSelected = true
        forwardButton.isSelected = false
        centerButton.isSelected = false
        userProfileImage.layer.borderColor = UIColor.white.cgColor
        userProfileImage.isUserInteractionEnabled = true
        
        firstNameTextField.layer.borderColor = UIColor.clearColor().CGColor
        lastNameTextField.layer.borderColor = UIColor.clearColor().CGColor
        homeCityTextField.layer.borderColor = UIColor.clearColor().CGColor
        heightTextField.layer.borderColor = UIColor.clearColor().CGColor
        weightTextField.layer.borderColor = UIColor.clearColor().CGColor
        birthDateTextField.layer.borderColor = UIColor.clearColor().CGColor
        sexTextField.layer.borderColor = UIColor.clearColor().CGColor
        favoritePlayerTextField.layer.borderColor = UIColor.clearColor().CGColor
        favoriteTeamTextField.layer.borderColor = UIColor.clearColor().CGColor
        aboutMeTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        var image = UIImage(named: "back")
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateProfileTableViewController.backButtonPressed))
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(CreateProfileTableViewController.registerUser))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.white], for: UIControlState.normal)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:45.0/255.0, green:47.0/255.0, blue:43.0/255.0, alpha:1.0)
    }
    
    //MARK:- IBActions
    @IBAction func positionButtonPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            guardButton.isSelected = true
            forwardButton.isSelected = false
            centerButton.isSelected = false
        case 1:
            guardButton.isSelected = false
            forwardButton.isSelected = true
            centerButton.isSelected = false
        case 2:
            guardButton.isSelected = false
            forwardButton.isSelected = false
            centerButton.isSelected = true
        default:
            break
        }
    }
    
    @IBAction func changeProfileImage(sender: AnyObject) {
        showActionSheet()
    }
    
    func backButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func registerUser() {
        pushToMainStoryboard()
    }
    
    func pushToMainStoryboard(){
        self.performSegue(withIdentifier: "LoginToMainSegue", sender: self)
        
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}


extension CreateProfileTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func camera()  {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func photoLibrary() {
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userProfileImage.contentMode = .scaleToFill
            userProfileImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

