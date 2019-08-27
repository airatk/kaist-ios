//
//  ScoreScreen.swift
//  kaist
//
//  Created by Airat K on 2/7/19.
//  Copyright © 2019 Airat K. All rights reserved.
//

import UIKit


class ScoreScreen: AUIExpandableTableViewController {
    
    private var lastAvailableSemester: Int?
    private let semesterPicker = UIPickerView()
    private var selectedSemester: Int!
    private let semesterInTitle = UIButton()
    private let semestersFetchingIndicator = UIActivityIndicatorView()
    
    private var initialScoretable: Student.Scoretable?
    
    private var tests: Student.Scoretable?
    private var evaluatedTests: Student.Scoretable?
    private var exams: Student.Scoretable?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpTitle()
        
        self.refreshControl?.addTarget(self, action: #selector(self.refreshScoretable), for: .valueChanged)
        self.tableView.register(ScoreCell.self, forCellReuseIdentifier: ScoreCell.reuseID)
        self.semesterPicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.initialScoretable == nil {
            let currentSemester = Int(AppDelegate.shared.student.year!)!*2 - (CurrentDay.isCurrentSemesterFirst ? 1 : 0)
            
            self.setSelectedSemester(currentSemester)
            self.lastAvailableSemester = currentSemester
            self.semesterPicker.selectRow(currentSemester - 1, inComponent: 0, animated: false)
            self.changeSemestersFetchingIndicatorVisibility(isHidden: true)
            
            self.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
            self.refreshControl?.beginRefreshing()
            self.refreshScoretable()
        }
    }
    
    
    private func setUpTitle() {
        self.semesterInTitle.titleLabel?.font = .boldSystemFont(ofSize: 17)
        self.semesterInTitle.setTitleColor(.black, for: .normal)
        self.semesterInTitle.setTitleColor(.gray, for: .highlighted)
        self.semesterInTitle.frame = self.navigationController!.navigationBar.frame
        self.semesterInTitle.addTarget(self, action: #selector(self.presentSemesterPickerSheet), for: .touchUpInside)
        
        self.semestersFetchingIndicator.color = .black
        self.semestersFetchingIndicator.frame = self.navigationController!.navigationBar.frame
        
        self.changeSemestersFetchingIndicatorVisibility(isHidden: false)
    }
    
    private func changeSemestersFetchingIndicatorVisibility(isHidden: Bool) {
        if isHidden {
            self.semestersFetchingIndicator.stopAnimating()
        } else {
            self.semestersFetchingIndicator.startAnimating()
        }
        
        self.navigationItem.titleView = isHidden ? self.semesterInTitle : self.semestersFetchingIndicator
    }
    
    private func setSelectedSemester(_ semester: Int?) {
        self.selectedSemester = semester ?? 0
        self.semesterInTitle.setTitle((semester == nil ? "Выбрать" : String(semester!)) + " семестр ▴▾", for: .normal)
    }
    
    private func setScoretable(_ scoretable: Student.Scoretable?) {
        self.initialScoretable = scoretable
        
        self.tests = scoretable?.filter { $0["type"] == "зачёт" }
        self.evaluatedTests = scoretable?.filter { $0["type"] == "зачёт с оценкой" }
        self.exams = scoretable?.filter { $0["type"] == "экзамен" }
    }
    
    
    @objc private func refreshScoretable() {
        AppDelegate.shared.student.getScoretable(forSemester: self.selectedSemester) { (scoretable, error) in
            if let error = error {
                self.tableView.backgroundView = AUIEmptyScreenView(message: error.rawValue)
            }
            
            self.setScoretable(scoretable)
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func presentSemesterPickerSheet() {
        self.changeSemestersFetchingIndicatorVisibility(isHidden: false)
        
        AppDelegate.shared.student.getLastAvailableSemester { (lastAvailableSemester, error) in
            self.lastAvailableSemester = lastAvailableSemester
            
            let semesterPickerSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            semesterPickerSheet.setValue({
                let semesterPickerController = UIViewController()
                
                semesterPickerController.view = error == nil ? self.semesterPicker : AUIEmptyScreenView(messageAtCenter: error!.rawValue)
                
                return semesterPickerController
            }(), forKey: "contentViewController")
            
            semesterPickerSheet.addAction(UIAlertAction(title: "Выбрано", style: .cancel, handler: { (_) in
                guard self.selectedSemester != self.semesterPicker.selectedRow(inComponent: 0) + 1 else { return }
                
                self.setSelectedSemester(error != nil ? nil : self.semesterPicker.selectedRow(inComponent: 0) + 1)
                
                self.tableView.setContentOffset(CGPoint(x: 0, y: -100), animated: true)
                self.refreshControl?.beginRefreshing()
                self.refreshScoretable()
            }))
            
            self.present(semesterPickerSheet, animated: true)
            self.changeSemestersFetchingIndicatorVisibility(isHidden: true)
        }
    }
    
}

extension ScoreScreen {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        tableView.backgroundView?.isHidden = self.initialScoretable != nil
        
        return self.initialScoretable == nil ? 0 : 3
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
        let scoreCell = tableView.dequeueReusableCell(withIdentifier: ScoreCell.reuseID, for: indexPath) as! ScoreCell
        
        var sectionScoretable: Student.Scoretable {
            switch indexPath.section {
                case 0: return self.tests!
                case 1: return self.evaluatedTests!
                case 2: return self.exams!
                
                default: return Student.Scoretable()
            }
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
        
        scoreCell.setScoreLine(.first,
            gained: sectionScoretable[indexPath.row]["1 gained"]!, maximum: sectionScoretable[indexPath.row]["1 maximum"]!)
        scoreCell.setScoreLine(.middle,
            gained: sectionScoretable[indexPath.row]["2 gained"]!, maximum: sectionScoretable[indexPath.row]["2 maximum"]!)
        scoreCell.setScoreLine(.last,
            gained: sectionScoretable[indexPath.row]["3 gained"]!, maximum: sectionScoretable[indexPath.row]["3 maximum"]!)
        
        return scoreCell
    }
    
}

extension ScoreScreen: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lastAvailableSemester!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 1)
    }
    
}
