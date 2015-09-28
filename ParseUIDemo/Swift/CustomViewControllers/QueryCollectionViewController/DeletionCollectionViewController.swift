//
//  DeletionCollectionViewController.swift
//  ParseUIDemo
//
//  Created by Richard Ross III on 5/14/15.
//  Copyright (c) 2015 Parse Inc. All rights reserved.
//

import UIKit

import Parse
import ParseUI

import Bolts.BFTask

class DeletionCollectionViewController: PFQueryCollectionViewController, UIAlertViewDelegate {
    convenience init(className: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        layout.minimumInteritemSpacing = 5.0

        self.init(collectionViewLayout: layout, className: className)

        title = "Deletion Collection"
        pullToRefreshEnabled = true
        objectsPerPage = 10
        paginationEnabled = true

        collectionView?.allowsMultipleSelection = true

        navigationItem.rightBarButtonItems = [
            editButtonItem(),
            UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTodo")
        ]
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            let bounds = UIEdgeInsetsInsetRect(view.bounds, layout.sectionInset)
            let sideLength = min(CGRectGetWidth(bounds), CGRectGetHeight(bounds)) / 2.0 - layout.minimumInteritemSpacing
            layout.itemSize = CGSizeMake(sideLength, sideLength)
        }
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

    @objc
    func addTodo() {
        if #available(iOS 8.0, *) {
            let alertDialog = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .Alert)

            var titleTextField : UITextField? = nil
            alertDialog.addTextFieldWithConfigurationHandler() {
                titleTextField = $0
            }

            alertDialog.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            alertDialog.addAction(UIAlertAction(title: "Save", style: .Default) { action in
                if let title = titleTextField?.text {
                    let object = PFObject(className: self.parseClassName!, dictionary: [ "title": title ])
                    object.saveEventually().continueWithSuccessBlock { _ -> AnyObject! in
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
        removeObjectsAtIndexPaths(collectionView?.indexPathsForSelectedItems())
    }

    // MARK - UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFCollectionViewCell? {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath, object: object)
        cell?.textLabel.textAlignment = .Center
        cell?.textLabel.text = object?["title"] as? String

        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.lightGrayColor().CGColor

        return cell
    }

    // MARK - UIAlertViewDelegate

    @objc
    func alertView(alertView: UIAlertView, didDismissWithButtonIndex buttonIndex: Int) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            return
        }

        if let title =  alertView.textFieldAtIndex(0)?.text {
            let object = PFObject(
                className: self.parseClassName!,
                dictionary: [ "title": title ]
            )
            
            object.saveEventually().continueWithSuccessBlock { _ -> AnyObject! in
                return self.loadObjects()
            }
        }
    }
}
