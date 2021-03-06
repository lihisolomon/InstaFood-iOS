//
//  FavoritesViewController.swift
//  InstaFood
//
//  Created by admin on 07/01/2018.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var favoritesTableView: UITableView!

    var favorites: [Recipe]?
    var rowNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set table view
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self
        //insert recipes into the array
        self.fetchFavorites()
        self.favoritesTableView.rowHeight = UITableViewAutomaticDimension
        self.favoritesTableView.rowHeight = 175
        self.favoritesTableView.backgroundView = UIImageView(image: UIImage(named: DEFAULT_BACKGROUND))
        self.favoritesTableView.backgroundView?.contentMode = UIViewContentMode.scaleAspectFit
    }
    //MARK: get user's favorites list
    func fetchFavorites(){
        RecipeData.recipeDataInstance.getFavoritesList(updateFavorites)
    }
    
    //MARK: upload the table view
    func updateFavorites(FavoritesArray: [Recipe]){
        self.favorites = FavoritesArray
        self.favoritesTableView.reloadData()
    }
    
    //Mark: recipe Choosen- need to view the full Recipe details
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print ("------------------")
        rowNum = indexPath.row
        print ("Recipe \(rowNum) selected")
        performSegue(withIdentifier: "RecipeDetails", sender: self)
    }
    
    //MARK: logout
    @IBAction func LogOut(_ sender: UIButton) {
        ScreenHandler.screenInstance.sendAlertToUserWithTwoOptions(vc: self, title: "Logout", body: "Are you sure you want to log out?", option1: "Logout", option2: "Cancel")
    }
    
    // MARK: table view settings
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.favorites != nil){
            return (self.favorites?.count)!
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.favorite = self.favorites?[indexPath.row]
        return cell
    }
    
    // MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeDetails" {
            let detailsVC = segue.destination as! RecipeViewViewController
            detailsVC.recipe = self.favorites?[rowNum]
            detailsVC.senderName = "Favorites"
        }
    }
}
