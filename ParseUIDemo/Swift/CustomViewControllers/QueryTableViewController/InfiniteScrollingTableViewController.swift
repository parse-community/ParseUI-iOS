//
//  InfiniteScrollingTableViewController.swift
//  ParseUI
//
//  Created by Eugenio Baglieri on 26/11/15.
//  Copyright © 2015 Parse Inc. All rights reserved.
//

import UIKit

import Parse
import ParseUI

class InfiniteScrollingTableViewController: PFQueryTableViewController {
    
    // MARK: Init
    
    convenience init(className: String?) {
        self.init(style: .Plain, className: className)
        
        title = "Infinite Scrolling Table"
        pullToRefreshEnabled = true
        objectsPerPage = 15
        paginationEnabled = true
        infiniteScrollingEnabled = true
    }
    
    // MARK: Data
    
    override func queryForTable() -> PFQuery {
        return super.queryForTable().orderByAscending("name")
    }
    
    // MARK: TableView
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        let cellIdentifier = "cell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? PFTableViewCell
        if cell == nil {
            cell = PFTableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.text = object?["name"] as? String
        
        return cell
    }
    
}

