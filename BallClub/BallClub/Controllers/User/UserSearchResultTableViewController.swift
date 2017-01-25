//
//  UserSearchResultTableViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 1/12/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit

class UserSearchResultTableViewController: UITableViewController {
  
  var playersArray = [Player]()
  var tempArray = [Player]()
  var selectedUser : Player?
  var delegate: AnyObject? = nil
  
}

extension UserSearchResultTableViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "pushFriendsVC" {
      let destinationNavigationController = segue.destination as! UINavigationController
      if let friendsVC: FriendsViewController = destinationNavigationController.topViewController as? FriendsViewController {
        if let user =  selectedUser {
          friendsVC.player = user
        }
      }
    }
  }
  
  //MARK: - tableView delegates
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    self.tableView.register(UINib(nibName: "UserSearchFriendsCustomCell",bundle: nil), forCellReuseIdentifier: "UserSearchFriendsCustomCell")
    return playersArray.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "UserSearchFriendsCustomCell") as? UserSearchFriendsCustomCell {
      cell.setFriendUserName(name: playersArray[indexPath.row].firstName + " " + playersArray[indexPath.row].lastName)
      cell.setFriendCity(city: playersArray[indexPath.row].city)
      if let imageString = playersArray[indexPath.row].avatar {
        cell.setFriendUserImage(image: imageString);
      }
      cell.tag = indexPath.row
      return cell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.selectedUser = self.playersArray[indexPath.row]
    dismiss(animated: true, completion: nil)
    self.performSegue(withIdentifier: "pushFriendsVC", sender: self)
  }
}

extension UserSearchResultTableViewController : UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchBarText = searchController.searchBar.text else { return }
    
    let searchArray = tempArray
    let filteredArray = searchArray.filter({ $0.firstName.lowercased().contains(searchBarText.lowercased())})
    
    if searchBarText.characters.count == 0 {
      playersArray = tempArray
    } else if filteredArray.count > 0 {
      playersArray =  filteredArray
    } else {
      playersArray = [Player]()
    }
    
    self.tableView.reloadData()
  }
}
