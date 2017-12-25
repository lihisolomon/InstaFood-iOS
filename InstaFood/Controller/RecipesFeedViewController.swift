//
//  RecipesFeedViewController.swift
//  InstaFood
//
//  Created by admin on 19/12/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit
import Firebase

class RecipesFeedViewController: UIViewController {
    
    let networkingService = NetworkingService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - LogOut
    @IBAction func LogOut(_ sender: Any) {
        print ("-------------------")
        do {
            try! Auth.auth().signOut()
            if Auth.auth().currentUser == nil {
                print ("Sign out Successfully")
                networkingService.MoveToLoginViewController()
            }
        }
        catch let error as NSError{
            print(error.localizedDescription)
        }
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
