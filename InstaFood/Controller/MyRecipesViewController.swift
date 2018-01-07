//
//  MyRecipesViewController.swift
//  InstaFood
//
//  Created by admin on 29/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class MyRecipesViewController: UIViewController {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var myRecipes: UITableView!
    
    let networkingService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkingService.getCurrentFullName(uploadFullName)
        networkingService.getImageFromURL(networkingService.getUserPicUrl(),success)
        // Do any additional setup after loading the view.
    }
    func uploadFullName(fullName: String){
        self.profileNameLabel.text = fullName
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func success(data : UIImage){
        profileImage.image = data
        
    }
    @IBAction func logoutIsPressed(_ sender: UIButton) {
    }
    
}
