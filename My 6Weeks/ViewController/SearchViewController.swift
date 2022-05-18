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
    
    var tasks: Results<UserDiary>! {
        didSet {
            searchTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableViewConfig()
        //렘 파일 위치 확인
        print("Realm is Located at:", localRealm.configuration.fileURL!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        readRealmData()
    }
    
    func readRealmData() {
        tasks = localRealm.objects(UserDiary.self).sorted(byKeyPath: "writeDate", ascending: false)
    }
    
    //도큐먼트 폴더 경로 -> 이미지 찾기 -> UIImage -> UIImageView
    func loadImageFromDocumentDirectory(imageName: String) -> UIImage? {
        
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)!
        }
        
        return nil
    }
    
    func deleteImageFromDocumentDirectory(imageName: String) {
        //1. 이미지 저장할 경로 설정: 도큐먼트 폴더 -> 고정이 되어있다.
        // for : 접근하고자 하는 폴더의 경로
        // in : 가져오고자 하는 경로의 값을 제한하는 속성
        
        //Desktop/bro/ios/folder -> 이 경로는 ios에서 계속 바뀌기 때문에 코드로 구현을 반드시 해야한다.
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                
        //2. 이미지 파일 이름 & 최종 경로설정
        //Desktop/bro/ios/folder/222.png
        //appendingPathComponent 함수를 통해 기존 도큐먼트 경로에 원하는 경로를 추가
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        
        //4. 이미지 삭제
        //4-1 이미지 경로 여부 확인
        if FileManager.default.fileExists(atPath: imageURL.path) {
            //4-2 기존 경로에 있는 이미지 삭제 -> 덮어쓰지만 삭제할 수도 있다는 것을 알려주는 것이다.
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("이미지 삭제 완료")
            } catch {
                print("이미지를 삭제하지 못했습니다")
            }
            
        }
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
                
        cell.diaryTitleLabel.text = diary.title
        cell.diaryContentLabel.text = diary.content
        cell.diaryDateLabel.text = "\(diary.writeDate)"
        cell.diaryImageView.image = loadImageFromDocumentDirectory(imageName: "\(diary._id).png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let deleteDiary = tasks[indexPath.row]
        
        try! localRealm.write {
            let imageName = "\(deleteDiary._id).png"
            deleteImageFromDocumentDirectory(imageName: imageName)
            localRealm.delete(deleteDiary)
            readRealmData()
        }
    }
    
    //본래는 화면전환 + 값 전달 후 새로운 화면에서 수정이 적합
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let updateDiary = tasks[indexPath.row]
        
        //1. 수정 -  하나의 레코드에 대한 값 수정
        try! localRealm.write {
            updateDiary.title = "업데이트!"
            updateDiary.content = "수정!!!!!!"
        }
        
        //2. 일괄 수정
//        try! localRealm.write {
//            tasks.setValue(Date(), forKey: "writeDate")
//            tasks.setValue("새롭게 일기 쓰기", forKey: "content")
//        }
        
        //3. 수정 : PK 기준으로 수정할 때 사용 (권장 x)
//        try! localRealm.write {
//            let update = UserDiary(value: [ "_id" : updateDiary._id, "title": "얘만바꾸고 싶어" ])
//            localRealm.add(update, update: .modified)
//        }
        
        //4.
//        try! localRealm.write {
//            localRealm.create(UserDiary.self, value: [ "_id" : updateDiary._id, "title": "얘만바꾸고 싶어" ], update: .modified)
//        }
        
        readRealmData()
    }
    
}
