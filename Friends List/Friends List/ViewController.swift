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
      fetchPeople()
    }
    
    private func fetchPeople() {

        //Fetch the data form Core Data to display in the tableview
        do {
            self.items = try context.fetch(Person.fetchRequest())
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
        alert.addAction(submitButton)
        
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

    
}
