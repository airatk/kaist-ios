//
//  ExpandableTableViewController.swift
//  Kaist
//
//  Created by Airat K on 19/8/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class ExpandableTableViewController: UITableViewController {

    private var absoluteMaximumBarOffsetY: CGFloat {
        44.0 + (self.tableView.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? -44.0)
    }

    private var previousBarsOffsetY: CGFloat = 0.0
    private var previousScrollViewContentOffsetY: CGFloat = 0.0


    override func loadView() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.showsHorizontalScrollIndicator = false

        self.tableView.backgroundView = EmptyView(emojiAtCenter: "✈️")

        self.refreshControl = UIRefreshControl()
    }

}

extension ExpandableTableViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let isAtTopEdge: Bool = scrollView.contentOffset.y < 0.0
        let isAtBottomEdge: Bool = scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.height)

        guard !isAtTopEdge && !isAtBottomEdge else {
            self.offsetBarsBy(dy: -self.previousBarsOffsetY, animated: true)
            self.previousBarsOffsetY = 0.0
            return
        }

        var dy: CGFloat = scrollView.contentOffset.y - self.previousScrollViewContentOffsetY

        if (self.previousBarsOffsetY + dy) > self.absoluteMaximumBarOffsetY {
            dy = self.absoluteMaximumBarOffsetY - self.previousBarsOffsetY
        } else if (self.previousBarsOffsetY + dy) < 0.0 {
            dy = -self.previousBarsOffsetY
        }

        // MARK: Decreasing bars' movement speed.
        dy /= 2

        self.offsetBarsBy(dy: dy, animated: false)

        self.previousBarsOffsetY += dy
        self.previousScrollViewContentOffsetY = scrollView.contentOffset.y
    }

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // MARK: Hiding bars only on arupt movements.
        guard !decelerate else { return }

        self.hideBarsAfterSmallScroll()
    }

    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.hideBarsAfterSmallScroll()
    }

}

extension ExpandableTableViewController {

    private func hideBarsAfterSmallScroll() {
        let isHalfOfBarsHidden: Bool = self.previousBarsOffsetY >= (self.absoluteMaximumBarOffsetY / 2.0)
        let dy: CGFloat = isHalfOfBarsHidden ? (self.absoluteMaximumBarOffsetY - self.previousBarsOffsetY) : -self.previousBarsOffsetY

        self.offsetBarsBy(dy: dy, animated: true)

        self.previousBarsOffsetY += dy
    }

    private func offsetBarsBy(dy: CGFloat, animated: Bool) {
        guard dy != 0.0 else { return }

        guard let navBar = self.navigationController?.navigationBar else { return }
        guard let tabBar = self.tabBarController?.tabBar else { return }

        UIView.animate(withDuration: animated ? 0.25 : 0, delay: animated ? 0.1 : 0, animations: {
            navBar.bounds = navBar.bounds.offsetBy(dx: 0, dy: dy)
            tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: dy)

            navBar.titleTextAttributes = [
                .foregroundColor: UIColor.label.withAlphaComponent(1.0 - navBar.bounds.origin.y / 34.0),
            ]
        }, completion: { _ in
            guard let appController = self.tabBarController as? AppController else { return }

            appController.statusBarBlur.isHidden = navBar.bounds.origin.y < 44.0
        })
    }

}
