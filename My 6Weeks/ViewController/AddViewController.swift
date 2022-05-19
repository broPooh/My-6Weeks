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
        
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        
        guard let buttonDate = diaryDateButton.currentTitle, let value = format.date(from: buttonDate) else { return }
        
        
        let diary = UserDiary(title: diaryTitleTextField.text!, content: diaryContentTextField.text!, writeDate: value, regDate: Date())
        try! localRealm.write {
            localRealm.add(diary)
            saveImageToDocumentDirectory(imageName: "\(diary._id).png", image: diaryImageView.image!)
            
            self.dismiss(animated: true, completion: nil)
        }
    }

    func saveImageToDocumentDirectory(imageName: String, image: UIImage) {
        //1. 이미지 저장할 경로 설정: 도큐먼트 폴더 -> 고정이 되어있다.
        // for : 접근하고자 하는 폴더의 경로
        // in : 가져오고자 하는 경로의 값을 제한하는 속성
        
        //Desktop/bro/ios/folder -> 이 경로는 ios에서 계속 바뀌기 때문에 코드로 구현을 반드시 해야한다.
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                
        //2. 이미지 파일 이름 & 최종 경로설정
        //Desktop/bro/ios/folder/222.png
        //appendingPathComponent 함수를 통해 기존 도큐먼트 경로에 원하는 경로를 추가
        let imageURL = documentDirectory.appendingPathComponent(imageName)
        
        //3. 이미지 압축 image.pngData()
        guard let data = image.jpegData(compressionQuality: 0.2) else { return }
        
        //4. 이미지 저장: 동일한 경로에 이미지를 저장하게 될 경우, 덮어쓰기
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
        
        
        //5. 이미지를 도큐먼트에 저장
        do {
            try data.write(to: imageURL)
        } catch {
            print("이미지 저장 못함")
        }
    }

    @IBAction func dateButtonClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "날짜 선택", message: "날짜를 선택해주세요", preferredStyle: .alert)
        
        //Alert Customizing
        //1. 얼럿 안에 들어와서 그런가?
        //2. 스토리보드가 인식이 안되나?
        //3. 스토리보드 씬 + 클래스 -> 화면전환 코드
        //let contentView = DatePickerViewController() // 코드만 가져오기에, 스토리보드와는 연결고리가 없다.
        
        guard let contentView = self.storyboard?.instantiateViewController(withIdentifier: Const.ViewController.DatePickerViewController) as? DatePickerViewController else {
            print("DatePickerVIewController에 오류가 있음")
            return
        }
        
        //contentView.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        contentView.preferredContentSize.height = 200
        
        alert.setValue(contentView, forKey: "contentViewController")
        
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            
            let format = DateFormatter()
            format.dateFormat = "yyy년 MM월 dd일"
            let value = format.string(from: contentView.datePicker.date)
            
            //확인 버튼을 눌렀을 때 버튼의 타이틀 변경
            self.diaryDateButton.setTitle(value, for: .normal)
            
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}
