	//
//  RecipesFeedViewController.swift
//  InstaFood
//
//  Created by admin on 19/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import SVProgressHUD

class RecipesFeedViewController:  UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var postsTableView: UITableView!
    
    let networkingService = NetworkingService()
    var recipes: [Recipe]?
    var rowNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        self.postsTableView.rowHeight = UITableViewAutomaticDimension
        self.postsTableView.rowHeight = 175
        self.postsTableView.backgroundView = UIImageView(image: UIImage(named: "Background.jpg"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveDataLocally), name: .APP_CLOESD_NOTIFICATION, object: nil)
        
        SVProgressHUD.show()
        guard let recipesData = UserDefaults.standard.object(forKey: "recipesArray") as? Data
        else {
            
            self.fetchPosts()
            return
        }
        guard let recipesFromLocal = NSKeyedUnarchiver.unarchiveObject(with: recipesData) as? [Recipe]
        else {
            print("Could not unarchive from placesData")
            return
        }
        NetworkingService.sharedInstance.uploadFeed(recipesFromLocal,updateRecipes)
        
    }
    
    func fetchPosts(){
        networkingService.getRecipesList(updateRecipes)
    }
    
    func updateRecipes(recipesArray: [Recipe]){
        self.recipes = recipesArray
        self.postsTableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    //Mark: recipe Choosen- need to view the full Recipe details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("------------------")
        rowNum = indexPath.row
        print ("Recipe \(rowNum) selected")
        performSegue(withIdentifier: "RecipeDetails", sender: self)
    }
    
    
    // MARK: - LogOut
    @IBAction func LogOut(_ sender: Any) {
        networkingService.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }
    
    // MARK: table view settings
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
    
    // MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetails" {
            let detailsVC = segue.destination as! RecipeViewViewController
            detailsVC.recipe = self.recipes?[rowNum]
        }
    }
    
    //Mark: when notification post, use to save data locally
    @objc func saveDataLocally(){
        print ("Notification called")
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: self.recipes), forKey: "recipesArray")
    }
}

