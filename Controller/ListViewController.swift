//
//  MainViewController.swift
//  FinalExamReview
//
//  Created by english on 2023-11-28.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InfoViewControllerDelegate {
    
    
    
    var selectedRow : Int?
    var usernameToDisplay: String?
    // this context var works like the "database connection".
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let entityName = Guest.entity().name!
    
    @IBOutlet weak var lblUsername: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()

    
    }
    func initialize(){
        
        tableView.dataSource = self
        tableView.delegate = self
        lblUsername.text = usernameToDisplay
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataProvider.all(context: self.context, entityName: entityName).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var cellContent = cell.defaultContentConfiguration()
        
        let guest = (CoreDataProvider.all(context: self.context, entityName: entityName)as! [Guest])[indexPath.row]
        
        cellContent.text = guest.name
        
        cell.selectionStyle = .none
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
    @IBAction func btnUpdateData(_ sender: Any) {
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        
        performSegue(withIdentifier: Segue.toInfoViewController, sender: nil)
    }
    func updateTable() {
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! InfoViewController
        
        if segue.identifier == Segue.toInfoViewController{
            
            destination.guest = (CoreDataProvider.all(context: self.context, entityName: entityName) as! [Guest])[self.selectedRow!]
        }
        
        destination.delegate = self
    }
    
    @IBAction func btnLogOffTapped(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
}
