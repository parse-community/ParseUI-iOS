//
//  DeletionTableViewController.swift
//  ParseUIDemo
//
//  Created by Richard Ross III on 5/13/15.
//  Copyright (c) 2015 Parse Inc. All rights reserved.
//

import UIKit

import Parse
import ParseUI

import Bolts.BFTask

class DeletionTableViewController: PFQueryTableViewController, UIAlertViewDelegate {

    // MARK: Init

    convenience init(className: String?) {
        self.init(style: .Plain, className: className)

        title = "Deletion Table"
        pullToRefreshEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelectionDuringEditing = true

        navigationItem.rightBarButtonItems = [
            editButtonItem(),
            UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTodo")
        ]
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        if (editing) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Trash,
                target: self,
                action: "deleteSelectedItems"
            )
        } else {
            navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
        }
    }

    override func tableView(tableView: UITableView,
      commitEditingStyle editingStyle: UITableViewCellEditingStyle,
          forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == .Delete) {
            removeObjectAtIndexPath(indexPath)
        }
    }

    @objc
    func addTodo() {
        
        if #available(iOS 8.0, *) {
            let alertDialog = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .Alert)

            var titleTextField : UITextField! = nil
            alertDialog.addTextFieldWithConfigurationHandler() {
                titleTextField = $0
            }

            alertDialog.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertDialog.addAction(UIAlertAction(title: "Save", style: .Default) { _ in
                if let title = titleTextField.text {
                    let object = PFObject(className: self.parseClassName!, dictionary: [ "title": title ])
                    object.saveInBackground().continueWithSuccessBlock { _ -> AnyObject! in
                        return self.loadObjects()
                    }
                }
            })

            presentViewController(alertDialog, animated: true, completion: nil)
        } else {
            let alertView = UIAlertView(
                title: "Add Todo",
                message: "",
                delegate: self,
                cancelButtonTitle: "Cancel",
                otherButtonTitles: "Save"
            )

            alertView.alertViewStyle = .PlainTextInput
            alertView.textFieldAtIndex(0)?.placeholder = "Name"

            alertView.show()
        }
    }

    @objc
    func deleteSelectedItems() {
        removeObjectsAtIndexPaths(tableView.indexPathsForSelectedRows)
    }

    // MARK - UIAlertViewDelegate

    @objc
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            return
        }

        if let title = alertView.textFieldAtIndex(0)?.text {
            let object = PFObject(className: self.parseClassName!, dictionary: [ "title": title ])
            object.saveEventually().continueWithSuccessBlock { _ -> AnyObject! in
                return self.loadObjects()
            }
        }
    }
}
