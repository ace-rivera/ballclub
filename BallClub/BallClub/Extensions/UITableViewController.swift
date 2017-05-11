//
//  UITableViewController.swift
//  BallClub
//
//  Created by Joshua Relova on 5/11/17.
//  Copyright © 2017 Geraldine Forto. All rights reserved.
//

import UIKit

extension UITableView {
    func removeHeaderSpace() {
        self.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0,
                                                    width: self.bounds.size.width, height: 0.01))
    }
}

