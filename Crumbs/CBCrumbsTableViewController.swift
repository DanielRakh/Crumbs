//
//  CBCrumbsTableViewController.swift
//  Crumbs
//
//  Created by Daniel on 11/15/15.
//  Copyright © 2015 Daniel Rakhamimov. All rights reserved.
//

import UIKit

class CBCrumbsTableViewController: UITableViewController {
    
    
    var viewModel:CBCrumbsTableViewModeling? {
        
        didSet {
            if let viewModel = viewModel {
                viewModel.cellModels.producer
                    .on(started: {
                        self.refreshControl?.beginRefreshing()
                        }, disposed: {
                           self.refreshControl?.endRefreshing()
                        }, next: {_ in
                            self.tableView.reloadData()
                            self.refreshControl?.endRefreshing()

                    })
                    .start()
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: .ValueChanged)
        viewModel?.startFetch()
    }
    

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        guard let viewModel = viewModel else {
            return 0
        }
        
        return viewModel.cellModels.value.count

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CrumbCell", forIndexPath: indexPath) as! CBCrumbCell
        
        guard let viewModel = viewModel else {
            cell.viewModel = nil
            return cell
        }
        
        cell.viewModel = viewModel.cellModels.value[indexPath.row]
        
        
        return cell
    }
    
    
    //MARK: - Table View Refresh
    
    func handleRefresh(refreshControl:UIRefreshControl) {
        viewModel?.startFetch()
    }



}
