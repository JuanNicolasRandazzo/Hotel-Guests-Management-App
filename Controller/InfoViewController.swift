//
//  InfoViewController.swift
//  FinalExamReview
//
//  Created by english on 2023-12-18.
//

import UIKit

protocol InfoViewControllerDelegate{
    
    func updateTable()
}

class InfoViewController: UIViewController {

    var guest : Guest?
    var delegate : InfoViewControllerDelegate?
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let entityName = Guest.entity().name!
    
    @IBOutlet weak var txtGuestName: UITextField!
    
    @IBOutlet weak var txtRoomNumber: UITextField!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
        // Do any additional setup after loading the view.
    }
    
    
    func initialize(){
        
        if guest != nil {
            
            txtGuestName.text = guest!.name
            txtRoomNumber.text = String(guest!.room)
            title = "Showing Guest"
            
            
        }
        else{
            
            title = "Adding New Guest"
            btnDelete.isHidden = true
        }
        
        
        
        
        
    }

    @IBAction func btnSaveTapped(_ sender: Any) {
        
        if guest == nil {
            
            if let existingGuest = (CoreDataProvider.findOne(context: self.context, entityName: entityName, key: "room", value: txtRoomNumber.text!) as? Guest){
                
                Toast.ok(view: self, title: "Oooops", message: "Room \(txtRoomNumber.text!) is already assigned to the Guest \(existingGuest.name!)")
                
                return
                
            }
            
            guest = Guest(context: self.context)
            let otherGuest = Guest()
            
            
        }
        guest!.name = txtGuestName.text!
        guest!.room = Int32(txtRoomNumber.text!)!
        let guestName = txtGuestName?.text
        let roomNum = Int(txtRoomNumber.text!)!
        
        if (guestName!.count >= 5 && guestName!.count <= 25 && roomNum >= 1000 && roomNum <= 1999){
            
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
        else {
            
            let alert = UIAlertController(title: "Error", message: "Guest must have between 5 and 25 characters and the room number must be betweem 1000 - 1999.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
            
        }
        
        
    }
    
    @IBAction func btnDeleteTouchUpInside(_ sender: Any) {
        
        do {
            try CoreDataProvider.delete(context: self.context, objectToDelete: self.guest!)
        } catch {
            Toast.ok(view: self, title: "Ooops", message: error.localizedDescription)
        }
        
        if delegate != nil {
            delegate!.updateTable()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
