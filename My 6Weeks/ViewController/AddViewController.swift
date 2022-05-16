//
//  AddViewController.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/14.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {
    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var diaryTitleTextField: UITextField!
    @IBOutlet weak var diaryDateButton: UIButton!
    
    @IBOutlet weak var diaryContentTextField: UITextField!
    
    let localRealm = try! Realm()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigation()
        
        //렘 파일 위치 확인
        //print("Realm is Located at:", localRealm.configuration.fileURL!)
    }
    
    func initNavigation() {
        
        title = "일기 작성"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(cancelButtonClicked))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
    
    @objc func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveButtonClicked() {
        
        let diary = UserDiary(title: diaryTitleTextField.text!, content: diaryContentTextField.text!, writeDate: Date(), regDate: Date())
        try! localRealm.write {
            localRealm.add(diary)
            self.dismiss(animated: true, completion: nil)
        }
    }


}
