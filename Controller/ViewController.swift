//
//  ViewController.swift
//  FinalExamReview
//
//  Created by english on 2023-11-28.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    // Conditions to log in and go to ListViewController
    
    @IBAction func btnLogInTouchUpInside(_ sender: Any) {
        
        let username = txtUsername?.text
        let password = txtPassword?.text
        
        if (username!.count >= 2 && password == "2235275"){
            
            
            self.performSegue(withIdentifier: Segue.toListViewController, sender: self)
            
        }
        else{
            
            let alert = UIAlertController(title: "Error", message: "Username or password are incorrect.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    // Prepare Sege for sending the username to the lebel in the List View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toListViewController" {
            if let destinationVC = segue.destination as? ListViewController {
                
                destinationVC.usernameToDisplay = txtUsername.text
            }
        }
        
    }
    
}
