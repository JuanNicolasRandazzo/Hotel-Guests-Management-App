//
//  MainViewController.swift
//  FinalExamReview
//
//  Created by english on 2023-11-28.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, InfoViewControllerDelegate {

    var selectedRow : Int?
    
    // this context var works like the "database connection".
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let entityName = Book.entity().name!


    @IBOutlet weak var lblLoggedUsername : UILabel!

    @IBOutlet weak var tableView : UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    func initialize() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return CoreDataProvider.all(context: self.context, entityName: entityName).count
        
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var cellContent = cell.defaultContentConfiguration()
        
        let book = (CoreDataProvider.all(context: self.context, entityName: entityName) as! [Book])[indexPath.row]
        cellContent.text = book.title
        cellContent.secondaryText = "IBAN: \(book.iban!)"
        
        cell.selectionStyle = .none
        cell.contentConfiguration = cellContent
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedRow = indexPath.row
        
        performSegue(withIdentifier: Segue.toInfoViewControllerEditing, sender: nil)
        
    }

    func updateTable() {
        
        tableView.reloadData()
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! InfoViewController
        
        if segue.identifier == Segue.toInfoViewControllerEditing {
            
            destination.book = (CoreDataProvider.all(context: self.context, entityName: entityName) as! [Book])[self.selectedRow!]
                        
        }

        destination.delegate = self
        
    }
    
    @IBAction func btnLogOffTapped( _ sender : Any? ) {
        
        navigationController?.popViewController(animated: true)
        
    }
}
