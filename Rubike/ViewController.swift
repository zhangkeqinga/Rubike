//
//  ViewController.swift
//  Rubike
//
//  Created by jhony on 14-10-10.
//  Copyright (c) 2014年 jhony. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SideMenuDelegate {
    
    var sideMenu : SideMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sideMenu = SideMenu(sourceView: self.view, menuData: ["UIDynamics", "UIGestures", "UIBlurEffect"])
        sideMenu!.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenuDidSelectItemAtIndex(index: Int) {
        sideMenu?.toggleMenu()
    }
    
    @IBAction func toggleSideMenu(sender: AnyObject) {
        sideMenu?.toggleMenu()
    }
    
    
}
