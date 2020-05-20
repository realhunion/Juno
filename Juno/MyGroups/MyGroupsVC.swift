//
//  MyGroupsVC.swift
//  Juno
//
//  Created by Hunain Ali on 5/19/20.
//  Copyright © 2020 BUMP. All rights reserved.
//

import UIKit

class MyGroupsVC: UITableViewController {
    
    var groupArray : [Group] = [Group(groupID: "fef", name: "The Family Room", memberIDArray: ["s","h","s","a"]), Group(groupID: "feff", name: "Project Corn", memberIDArray: ["s","h","j"])]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(SubtitleTableViewCell.classForCoder(), forCellReuseIdentifier: "groupCell")
        
        self.title = "My Groups"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groupArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        
        let group = self.groupArray[indexPath.row]

        cell.textLabel?.text = group.name
        cell.detailTextLabel?.text = "\(group.memberIDArray.count) members"
        return cell
    }
    
    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = UIColor.white
        nameLabel.textColor = UIColor.systemPink
        
        nameLabel.font = UIFont.systemFont(ofSize: 112.0, weight: .heavy)
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
