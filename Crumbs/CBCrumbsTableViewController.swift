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
                    .on(next: {_ in self.tableView.reloadData()})
                    .start()
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.startFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let viewModel = viewModel {
            return viewModel.cellModels.value.count
        }
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CrumbCell", forIndexPath: indexPath) as! CBCrumbCell
        
        if let viewModel = viewModel {
            cell.viewModel = viewModel.cellModels.value[indexPath.row]
        } else {
            cell.viewModel = nil
        }
        

        return cell
        
    }



}
