// MasterViewController.swift
//
// Copyright (c) 2015 Shintaro Kaneko
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import Realm

class Object: RLMObject {
    dynamic var title = ""
    dynamic var date = NSDate()
}

class MasterViewController: UITableViewController {

    var array = Object.allObjects().sortedResultsUsingProperty("date", ascending: true)
    var notificationToken: RLMNotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton

        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.tableView.reloadData()
        }
        tableView.reloadData()
    }

    func insertNewObject(sender: AnyObject) {
        let realm = RLMRealm.defaultRealm()
        let title = NSDate().description
        realm.beginWriteTransaction()
        Object.createInRealm(realm, withObject: [title, NSDate()])
        realm.commitWriteTransaction()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = array[UInt(indexPath.row)] as Object
                (segue.destinationViewController as DetailViewController).detailItem = object.date
            }
        }
    }

    // MARK: - Table View

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(array.count)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let object = array[UInt(indexPath.row)] as Object
        cell.textLabel?.text = object.title
        cell.detailTextLabel?.text = object.date.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            realm.deleteObject(array[UInt(indexPath.row)] as RLMObject)
            realm.commitWriteTransaction()
        }
    }

}

