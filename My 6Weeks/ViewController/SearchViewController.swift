//
//  SearchViewController.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/14.
//

import UIKit
import RealmSwift

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    
    let localRealm = try! Realm()
    
    var tasks: Results<UserDiary>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableViewConfig()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasks = localRealm.objects(UserDiary.self)
    }
    
    func searchTableViewConfig() {
        searchTableView.delegate = self
        searchTableView.dataSource = self
        connectSearchCell()
    }
    
    func connectSearchCell() {
        //XIB 파일 연결
        let nibName = UINib(nibName: Const.CustomCell.SearchTableViewCell, bundle: nil)
        searchTableView.register(nibName, forCellReuseIdentifier: Const.CustomCell.SearchTableViewCell)
    }
        
}

// MARK: - TableView delegate, datasource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.CustomCell.SearchTableViewCell) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let diary = tasks[indexPath.row]
        print(diary)
        
        cell.diaryTitleLabel.text = diary.title
        cell.diaryContentLabel.text = diary.content
        cell.diaryDateLabel.text = "\(diary.writeDate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}
