//
//  SideMenu.swift
//  SwiftSideMenu
//
//  Created by Evgeny on 24.07.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

@objc protocol SideMenuDelegate {
    func sideMenuDidSelectItemAtIndex(index:Int)
    optional func sideMenuWillOpen()
    optional func sideMenuWillClose()
}

class SideMenu : NSObject, MenuTableViewControllerDelegate {
    
    let menuWidth : CGFloat = 260.0
    let menuTableViewTopInset : CGFloat = 64.0 // if you use translusent navigation bar
    let sideMenuContainerView =  UIView()
    let sideMenuTableViewController = MenuTableViewController()
    var animator : UIDynamicAnimator!
    let sourceView : UIView!
    var delegate : SideMenuDelegate?
    var isMenuOpen : Bool = false
    
    init(sourceView: UIView, menuData:Array<String>) {
        super.init()
        self.sourceView = sourceView
        self.sideMenuTableViewController.tableData = menuData
        self.setupMenuView()
        
        animator = UIDynamicAnimator(referenceView:sourceView)
        
        // Add show gesture recognizer
        var showGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleGesture:"))
        showGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Right
        sourceView.addGestureRecognizer(showGestureRecognizer)
        
        // Add hide gesture recognizer
        var hideGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("handleGesture:"))
        hideGestureRecognizer.direction = UISwipeGestureRecognizerDirection.Left
        sideMenuContainerView.addGestureRecognizer(hideGestureRecognizer)
    }
    
    
    func setupMenuView() {
        
        // Configure side menu container
        sideMenuContainerView.frame = CGRectMake(-menuWidth-1.0, sourceView.frame.origin.y, menuWidth, sourceView.frame.size.height)
        sideMenuContainerView.backgroundColor = UIColor.clearColor()
        sideMenuContainerView.clipsToBounds = false
        sideMenuContainerView.layer.masksToBounds = false;
        sideMenuContainerView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        sideMenuContainerView.layer.shadowRadius = 1.0;
        sideMenuContainerView.layer.shadowOpacity = 0.125;
        sideMenuContainerView.layer.shadowPath = UIBezierPath(rect: sideMenuContainerView.bounds).CGPath

        sourceView.addSubview(sideMenuContainerView)
        
        // Add blur view
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = sideMenuContainerView.bounds
        sideMenuContainerView.addSubview(visualEffectView)
        
        // Configure side menu table view
        sideMenuTableViewController.delegate = self
        sideMenuTableViewController.tableView.frame = sideMenuContainerView.bounds
        sideMenuTableViewController.tableView.clipsToBounds = false
        sideMenuTableViewController.tableView.separatorStyle = .None
        sideMenuTableViewController.tableView.backgroundColor = UIColor.clearColor()
        sideMenuTableViewController.tableView.scrollsToTop = false
        sideMenuTableViewController.tableView.contentInset = UIEdgeInsetsMake(menuTableViewTopInset, 0, 0, 0)
        
        sideMenuTableViewController.tableView.reloadData()
        
        sideMenuContainerView.addSubview(sideMenuTableViewController.tableView)
    }
    
    //guster action
    func handleGesture(gesture: UISwipeGestureRecognizer) {
        
        if (gesture.direction == .Left) {
            toggleMenu(false)
             delegate?.sideMenuWillClose?()
        }
        else{
            toggleMenu(true)
             delegate?.sideMenuWillOpen?()
        }
    }
    
    //改变菜单位子
    func toggleMenu (shouldOpen: Bool) {
        
        animator.removeAllBehaviors()
        isMenuOpen = shouldOpen
        let gravityDirectionX: CGFloat = (shouldOpen) ? 0.5 : -0.5;
        let pushMagnitude:     CGFloat = (shouldOpen) ? 20.0 : -20.0;
        let boundaryPointX:    CGFloat = (shouldOpen) ? menuWidth : -menuWidth-1.0;
        
        let gravityBehavior = UIGravityBehavior(items: [sideMenuContainerView])
        gravityBehavior.gravityDirection = CGVectorMake(gravityDirectionX, 0.0)
        animator.addBehavior(gravityBehavior)//重力行为
        
        let collisionBehavior = UICollisionBehavior(items: [sideMenuContainerView])
        collisionBehavior.addBoundaryWithIdentifier("menuBoundary", fromPoint: CGPointMake(boundaryPointX, 20.0),
            toPoint: CGPointMake(boundaryPointX, sourceView.frame.size.height))
        animator.addBehavior(collisionBehavior)//碰撞行为
        
        let pushBehavior = UIPushBehavior(items: [sideMenuContainerView], mode: UIPushBehaviorMode.Instantaneous)
        pushBehavior.magnitude = pushMagnitude
        animator.addBehavior(pushBehavior)//推动行为
        
        let menuViewBehavior = UIDynamicItemBehavior(items: [sideMenuContainerView])
        menuViewBehavior.elasticity = 0.3
        animator.addBehavior(menuViewBehavior)//
    }
    
    func menuControllerDidSelectRow(indexPath:NSIndexPath) {  
         delegate?.sideMenuDidSelectItemAtIndex(indexPath.row)
    }
    
    func toggleMenu () {
        if (isMenuOpen) {
            toggleMenu(false)
        }
        else {
            toggleMenu(true)
        }
    }
}