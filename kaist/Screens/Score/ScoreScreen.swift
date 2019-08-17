//
//  ScoreScreen.swift
//  kaist
//
//  Created by Airat K on 2/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class ScoreScreen: UITableViewController {
    
    private var lastAvailableSemester: Int?
    private var selectedSemester: Int? = 1
    
    private var scoretable: [[String: String]]?
    
    private var tests: [[String: String]]?
    private var evaluatedTests: [[String: String]]?
    private var exams: [[String: String]]?
    
    
    private let semesterPicker = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = {
            let tableView = UITableView(frame: .zero, style: .grouped)
            
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            
            tableView.backgroundColor = .white
            tableView.backgroundView = EmptyScreenView(emoji: "✈️", emojiSize: 50, isEmojiCentered: true)
            
            self.semesterPicker.dataSource = self
            self.semesterPicker.delegate = self
            tableView.tableHeaderView = self.semesterPicker
            
            tableView.register(ScoreCell.self, forCellReuseIdentifier: ScoreCell.ID)
            
            return tableView
        }()
        
        self.navigationItem.title = "1 семестр"
        
        self.refreshControl = {
            let refreshControl = UIRefreshControl()
            
            refreshControl.addTarget(self, action: #selector(self.refreshScoretable), for: .valueChanged)
            
            return refreshControl
        }()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.scoretable == nil {
            self.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
            self.refreshControl?.beginRefreshing()
            self.refreshScoretable()
        }
    }
    
    
    private func splitScoretable() {
        self.tests = self.scoretable?.filter { $0["type"] == "зачёт" }
        self.evaluatedTests = self.scoretable?.filter { $0["type"] == "зачёт с оценкой" }
        self.exams = self.scoretable?.filter { $0["type"] == "экзамен" }
    }
    
    
    @objc private func refreshScoretable() {
        AppDelegate.shared.student.getLastAvailableSemester { (lastAvailableSemester, error) in
            if let error = error {
                self.tableView.backgroundView = EmptyScreenView(emoji: "🤷🏼‍♀️", message: error.rawValue)
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            } else {
                self.lastAvailableSemester = lastAvailableSemester
                self.semesterPicker.reloadAllComponents()
                
                AppDelegate.shared.student.getScoretable(forSemester: self.selectedSemester ?? 0) { (scoretable, error) in
                    if let error = error {
                        self.tableView.backgroundView = EmptyScreenView(emoji: "🤷🏼‍♀️", message: error.rawValue)
                    }
                    
                    self.scoretable = scoretable
                    self.splitScoretable()
                    
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
}

extension ScoreScreen {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = self.scoretable != nil
        
        return self.scoretable == nil ? 0 : 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0: return self.tests?.count ?? 0
            case 1: return self.evaluatedTests?.count ?? 0
            case 2: return self.exams?.count ?? 0
            
            default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            case 0: return "зачёты"
            case 1: return "зачёты с оценкой"
            case 2: return "экзамены"
            
            default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        
        headerView.textLabel?.textColor = UIColor.darkGray.withAlphaComponent(0.8)
        headerView.textLabel?.font = .boldSystemFont(ofSize: 12)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scoreCell = tableView.dequeueReusableCell(withIdentifier: ScoreCell.ID, for: indexPath) as! ScoreCell
        
        var sectionScoretable: [[String: String]]
        
        switch indexPath.section {
            case 0: sectionScoretable = self.tests!
            case 1: sectionScoretable = self.evaluatedTests!
            case 2: sectionScoretable = self.exams!
            
            default: sectionScoretable = [[:]]
        }
        
        scoreCell.title.text = sectionScoretable[indexPath.row]["title"]
        scoreCell.debts.text = {
            let debts = Int(sectionScoretable[indexPath.row]["debts"]!)!
            
            switch debts {
                case 1: return "\(debts) долг"
                case 2, 3, 4: return "\(debts) долга"
                
                default: return "\(debts) долгов"
            }
        }()
        
        let gained1 = sectionScoretable[indexPath.row]["1 gained"]!
        let gained2 = sectionScoretable[indexPath.row]["2 gained"]!
        let gained3 = sectionScoretable[indexPath.row]["3 gained"]!
        
        let maximum1 = sectionScoretable[indexPath.row]["1 maximum"]!
        let maximum2 = sectionScoretable[indexPath.row]["2 maximum"]!
        let maximum3 = sectionScoretable[indexPath.row]["3 maximum"]!
        
        scoreCell.setScoreLineWidth(withMultiplier: maximum1 == "0" ? 0 : CGFloat(Int(gained1)!)/CGFloat(Int(maximum1)!), scoreLine: .first)
        scoreCell.setScoreLineWidth(withMultiplier: maximum2 == "0" ? 0 : CGFloat(Int(gained2)!)/CGFloat(Int(maximum2)!), scoreLine: .middle)
        scoreCell.setScoreLineWidth(withMultiplier: maximum3 == "0" ? 0 : CGFloat(Int(gained3)!)/CGFloat(Int(maximum3)!), scoreLine: .last)
        
        scoreCell.sertification1Gained.text = maximum1 == "0" ? nil : gained1
        scoreCell.sertification2Gained.text = maximum2 == "0" ? nil : gained2
        scoreCell.sertification3Gained.text = maximum3 == "0" ? nil : gained3
        
        scoreCell.sertification1Maximum.text = maximum1
        scoreCell.sertification2Maximum.text = maximum2
        scoreCell.sertification3Maximum.text = maximum3
        
        return scoreCell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ScoreScreen {
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard self.scoretable != nil else { return }
        
        self.changeBarsVisibility(isHidden: scrollView.panGestureRecognizer.translation(in: scrollView).y <= 0)
    }

    override func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        self.changeBarsVisibility(isHidden: false)

        return true
    }


    private func changeBarsVisibility(isHidden: Bool) {
        guard self.navigationController?.navigationBar.isHidden != isHidden else { return }

        guard let navBar = self.navigationController?.navigationBar else { return }
        guard let tabBar = self.tabBarController?.tabBar else { return }

        navBar.isHidden = false
        tabBar.isHidden = false

        UIView.animate(withDuration: 0.25, animations: {
            (UIApplication.shared.value(forKey: "statusBar") as! UIView).backgroundColor = isHidden ? .white : .clear
            
            navBar.frame = navBar.frame.offsetBy(dx: 0, dy: isHidden ? -navBar.frame.height : navBar.frame.height)
            tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: isHidden ? tabBar.frame.height : -tabBar.frame.height)
        }, completion: { _ in
            navBar.isHidden = isHidden
            tabBar.isHidden = isHidden
        })
    }
    
}

extension ScoreScreen: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lastAvailableSemester ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.navigationItem.title = "\(row + 1) семестр"
        self.selectedSemester = row + 1
        
        self.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
        self.refreshControl?.beginRefreshing()
        self.refreshScoretable()
    }
    
}
