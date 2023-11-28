//
//  MainViewController.swift
//  FinalExamReview
//
//  Created by english on 2023-11-28.
//

import UIKit

protocol InfoViewControllerDelegate {
    
    func updateTable()
    
}


class InfoViewController: UIViewController {

    var book : Book?
    
    var delegate : InfoViewControllerDelegate?

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let entityName = Book.entity().name!
    
    @IBOutlet weak var txtIban : UITextField!
    
    @IBOutlet weak var txtTitle : UITextField!

    @IBOutlet weak var btnDelete : UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initialize()
    }
    
    func initialize(){
        
        if book != nil {
            txtIban.text = book!.iban
            txtIban.isEnabled = false
            txtTitle.text = book!.title
            title = "Updating book"
        } else {
            title = "Adding new book"
            btnDelete.isHidden = true
        }
        
    }
    
    @IBAction func btnDeleteTapped( _ sender : Any? ) {
        
        do {
            try CoreDataProvider.delete(context: self.context, objectToDelete: self.book!)
        } catch {
            Toast.ok(view: self, title: "Ooops", message: error.localizedDescription)
        }
        
        if delegate != nil {
            delegate!.updateTable()
        }
        
        navigationController?.popViewController(animated: true)
        
    }

    @IBAction func btnSaveTapped( _ sender : Any? ) {
        
        if book == nil {
            
            if let existingBook = (CoreDataProvider.findOne(context: self.context, entityName: entityName, key: "iban", value: txtIban.text!) as? Book) {
                Toast.ok(view: self, title: "Ooops", message: "IBAN \(txtIban.text!) is already assigned to book title \(existingBook.title!)")
                return
            }
            
            book = Book(context: self.context)
        }

        book!.iban = txtIban.text!
        book!.title = txtTitle.text!

        do{
            try CoreDataProvider.save(context: self.context)
        } catch {
            Toast.ok(view: self, title: "Oops", message: error.localizedDescription)
        }
        
        if delegate != nil {
            delegate!.updateTable()
        }
        
        navigationController?.popViewController(animated: true)
        
    }

    
}
