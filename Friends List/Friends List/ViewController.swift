//
//  ViewController.swift
//  Friends List
//
//  Created by Aurelio Le Clarke on 25.08.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
    //Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //Data for the Table
    var items: [Person]?

     
    let tableView: UITableView = {

        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table

    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        addingTopButton()
        
        tableView.delegate = self
        
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        fetchPeople()
    }
    
    private func fetchPeople() {

        
        //Fetch the data form Core Data to display in the tableview
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            //set the filtering and sorting on the request
//            let pred = NSPredicate(format: "name CONTAINS %@", "Teddy")
//            request.predicate = pred
            
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
          
        }catch {
            
        }

        }
    
    
   private func addingTopButton() {
        
       let navBar = UINavigationBar(frame: CGRect(x: 0, y: 50, width: view.frame.size.width, height: 50))
       view.addSubview(navBar)

       let navItem = UINavigationItem(title: "My Friends")
       let doneItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(addingFriend))
//       navBar.backgroundColor = .systemTeal
       navItem.rightBarButtonItem = doneItem

       navBar.setItems([navItem], animated: true)
   
    }
    
    
    @objc private func addingFriend() {
       //creating alert
        let alert = UIAlertController(title: "Add Friend", message: "What is his name?", preferredStyle: .alert)
        alert.addTextField()
        //Configure button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
           //Get the textfield for the alert
            let textField = alert.textFields![0]
            
            //Create new person
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 20
            newPerson.gender = "Male"
            
            //Save the Data
            do {
                try self.context.save()
            }
            catch {
                
            }
            //Re fetch the data
            self.fetchPeople()
        }
        //Add button
        alert.addAction(submitButton)
        
        //Show alert
        self.present(alert, animated: true,completion: nil)
        }
    
  

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
}

//MARK: - Extension of Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.items?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person =  self.items![indexPath.row]
        cell.textLabel?.text = person.name
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Select person
        let person =  self.items![indexPath.row]
        
        //Create alert
        let alert = UIAlertController(title: "Edit person", message: "Edit name ", preferredStyle: .alert)
        alert.addTextField()
        let textfield = alert.textFields![0]
        textfield.text = person.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            //Get the textfield for the alert
            let textfield  = alert.textFields![0]
            
            //Edit name property or person
            person.name = textfield.text
            //Save the data
            do {
                try self.context.save()
            } catch {
                
            }
            //Re fetch the data
            self.fetchPeople()
        }

            //add button
        alert.addAction(saveButton)
        
        //Show alert
        self.present(alert, animated: true,completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Create swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            //Which person to remove
            let personToRemove = self.items![indexPath.row]
            
            //Remove the person
            self.context.delete(personToRemove)
            
            //Save the data
            do {
            try self.context.save()
                
            } catch {
                
            }
            //Re fetch the data
            self.fetchPeople()
            
            }
        
        
        //Return swipe action
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
