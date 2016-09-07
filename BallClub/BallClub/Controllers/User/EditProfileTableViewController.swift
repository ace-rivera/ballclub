//
//  EditProfileTableViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 9/7/16.
//  Copyright © 2016 Geraldine Forto. All rights reserved.
//

import UIKit
import MaterialKit



class EditProfileTableViewController: UITableViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        setupUi()
    }

    //MARK:- SetupUI
    func setupUi(){
        guardButton.selected = true
        forwardButton.selected = false
        centerButton.selected = false
        userProfileImage.layer.borderColor = UIColor.whiteColor().CGColor
        userProfileImage.userInteractionEnabled = true
        
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
        
        self.navigationController?.navigationBar.hidden = false
        var image = UIImage(named: "back")
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditProfileTableViewController.backButtonPressed))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(EditProfileTableViewController.saveProfileChanges))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Normal)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    //MARK:- IBActions
    @IBAction func positionButtonPressed(sender: UIButton) {
        switch sender.tag {
        case 0:
            guardButton.selected = true
            forwardButton.selected = false
            centerButton.selected = false
        case 1:
            guardButton.selected = false
            forwardButton.selected = true
            centerButton.selected = false
        case 2:
            guardButton.selected = false
            forwardButton.selected = false
            centerButton.selected = true
        default:
            break
        }
    }
    
    @IBAction func changeProfileImage(sender: AnyObject) {
        showActionSheet()
    }
    
    func backButtonPressed(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func saveProfileChanges() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }


 

}

extension EditProfileTableViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
            userProfileImage.contentMode = .ScaleToFill
            userProfileImage.image = pickedImage
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
