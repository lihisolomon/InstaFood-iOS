//
//  RecipesFeedViewController.swift
//  InstaFood
//
//  Created by admin on 19/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class RecipesFeedViewController:  UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var postsTableView: UITableView!
    
    let networkingService = NetworkingService()
    var recipes: [Recipe]?
    
    struct Storyboad{
        static let postCell = "PostCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        self.fetchPosts()
        postsTableView.rowHeight = UITableViewAutomaticDimension
        postsTableView.separatorColor = UIColor.clear
    }
    
    func fetchPosts(){
        self.recipes =	Recipe.fetchPosts()
        self.postsTableView.reloadData()
    }

    // MARK: - LogOut
    @IBAction func LogOut(_ sender: Any) {
        networkingService.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let recipes = recipes{
            return recipes.count
        }
        else {
            return 0
        }
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = recipes{
            return 1
        }
        else {
           return 0;
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboad.postCell, for: indexPath) as! PostCell
        cell.post = self.recipes?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
