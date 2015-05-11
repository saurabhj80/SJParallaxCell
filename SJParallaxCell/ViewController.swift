//
//  ViewController.swift
//  SJParallaxCell
//
//  Created by Saurabh Jain on 5/10/15.
//  Copyright (c) 2015 Saurabh Jain. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var tableView: UITableView!
    private let kCellIdentifier = "Cell"
    
    private var img_arr = [UIImage?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(SJParallaxCell.self, forCellReuseIdentifier: kCellIdentifier)
        
        for i in 1..<15 {
            let img = UIImage(named: "\(i)")
            img_arr.append(img)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return img_arr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier, forIndexPath: indexPath) as! SJParallaxCell
        cell.sj_parallaxImage = img_arr[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200
    }
}

