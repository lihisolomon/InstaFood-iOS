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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        self.fetchPosts()
        postsTableView.rowHeight = UITableViewAutomaticDimension
        //postsTableView.estimatedRowHeight = 200.0
        postsTableView.rowHeight = 175
        //postsTableView.separatorColor = UIColor.clear
        
    }
    
    func fetchPosts(){
        networkingService.getRecipesList(updataeRecipes)
    }
    
    func updataeRecipes(recipesArray: [Recipe]){
        self.recipes = recipesArray
        self.postsTableView.reloadData()    }
    
    // MARK: - LogOut
    @IBAction func LogOut(_ sender: Any) {
        networkingService.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.recipes != nil){
            return (self.recipes?.count)!
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.post = self.recipes?[indexPath.row]
        //cell.selectionStyle = .none
        return cell
    }
}

