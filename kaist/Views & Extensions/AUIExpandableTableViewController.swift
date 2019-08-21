//
//  AUIExpandableTableViewController.swift
//  kaist
//
//  Created by Airat K on 19/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class AUIExpandableTableViewController: UITableViewController {
    
    // Dynamic top bar height which fits great both of iPhone 8 & iPhone X
    private var absoluteMaximumBarOffsetY: CGFloat = 44 + UIApplication.shared.statusBarFrame.height
    private var previousBarsOffsetY: CGFloat = 0
    private var previousScrollViewContentOffsetY: CGFloat = 0
    
    
    override func viewDidLoad() {
        self.tableView = {
            let tableView = UITableView(frame: .zero, style: .grouped)
            
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            
            tableView.backgroundColor = .white
            tableView.backgroundView = AUIEmptyScreenView(emojiAtCenter: "✈️")
            
            return tableView
        }()
        
        self.refreshControl = UIRefreshControl()
    }
    
}

extension AUIExpandableTableViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y >= 0 &&  // Is not at the top edge
            scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.height  // Is not at the bottom adge
        else {
            self.offsetBarsBy(dy: -self.previousBarsOffsetY, animated: true)
            self.previousBarsOffsetY = 0
            return
        }
        
        var dy = scrollView.contentOffset.y - self.previousScrollViewContentOffsetY
        
        if (self.previousBarsOffsetY + dy) > self.absoluteMaximumBarOffsetY {  // Bottom bound
            dy = self.absoluteMaximumBarOffsetY - self.previousBarsOffsetY
        } else if (self.previousBarsOffsetY + dy) < 0 {  // Top bound
            dy = -self.previousBarsOffsetY
        }
        
        dy /= 2  // Slowing down bars' movement
        
        self.offsetBarsBy(dy: dy, animated: false)
        self.previousBarsOffsetY += dy
        self.previousScrollViewContentOffsetY = scrollView.contentOffset.y
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }  // Hiding bars only on arupt movements
        
        self.hideBarsAfterSmallScroll()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.hideBarsAfterSmallScroll()
    }
    
    
    private func hideBarsAfterSmallScroll() {
        let dy = self.previousBarsOffsetY >= self.absoluteMaximumBarOffsetY/2 ? self.absoluteMaximumBarOffsetY - self.previousBarsOffsetY : -self.previousBarsOffsetY
        
        self.offsetBarsBy(dy: dy, animated: true)
        self.previousBarsOffsetY += dy
    }
    
    private func offsetBarsBy(dy: CGFloat, animated: Bool) {
        guard let navBar = self.navigationController?.navigationBar else { return }
        guard let tabBar = self.tabBarController?.tabBar else { return }
        
        UIView.animate(withDuration: animated ? 0.25 : 0, delay: animated ? 0.1 : 0, animations: {
            navBar.frame = navBar.frame.offsetBy(dx: 0, dy: -dy)
            tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: dy)
        }, completion: { (_) in
            AppDelegate.shared.statusBarBlur.isHidden = self.previousBarsOffsetY < 1
        })
    }
    
}
