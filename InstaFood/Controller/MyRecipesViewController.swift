//
//  MyRecipesViewController.swift
//  InstaFood
//
//  Created by admin on 29/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class MyRecipesViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    let networkingService = NetworkingService()
    @IBAction func editButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkingService.getCurrentFullName(uploadFullName)
        networkingService.getImageFromURL(networkingService.getUserPicUrl(),success,failure)
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
    func failure(data : UIImage) {
         profileImage.image = data
         networkingService.sendAlertToUser(self, titleAlert: "Error", messageAlert: "no picture found in firebase storage")
        print("Could not find pic in firebase storage")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
