//
//  SettingViewController.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/17.
//

import UIKit
import RealmSwift
import Zip
import MobileCoreServices

/*
 백업하기
 - 사용자의 아이폰 저장 공간 확인
    - 부족: 백업 불가
 - 백업 진행
    - 어떤 데이터도 없는 경우라면 백업할 데이터가 없다고 안내
    - 백업 가능한 파일 여부 확인 realm, folder
    - Progress + UI 인터렉션 금지
 - zip
    - 백업 완료 시점에
    - Progress + UI 인터렉션 허용
 - 공유화면
 */

/*
 복구하기
 - 사용자의 아이폰 저장 공간 확인
    - 부족: 복구 불가
 - 파일 앱으로 백업파일이 있는지 확인
    - zip 파일이 아닌 친구들은 거절
    - zip 파일만 선택
 - zip -> unZip
    - 압축해제전 백업 파일 이름 확인
    - 압축해제
        - 압축 해제후 백업파일 확인 : 폴더, 백업 파일 이름이 내가 지정한 형태가 맞는지
        - 정상적인 파일인지 확인
 - 백업 당시 데이터랑 지금 현재 앱에서 사용중인 데이터 어떻게 합칠건지
    - 백업 데이터 선택
 */

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func documentDirectoryPath() -> String? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            return directoryPath
        } else {
            return nil
        }
        
    }
    
    //7. 공유
    func presentActivityViewController() {
        //압축 파일 경로 가져오기
        let fileName = (documentDirectoryPath()! as NSString).appendingPathComponent("archive.zip")
        let fileURL = URL(fileURLWithPath: fileName)
        
        //activityItems : 공유하고자 하는 것이 파일 이미지 스트링 등 여러 타입이 들어갈 수 있기 떄문에 Any로 선언
        //applicationActivities: 공유의 확장기능이라 지금 당장은 필요하지 않아서 생략
        let vc = UIActivityViewController(activityItems: [fileURL], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backupButtonClicked(_ sender: UIButton) {
        //4. 백업할 파일에 대한 URL 배열
        var urlPaths = [URL]()
        
        //1. 도큐먼트 폴더 위치
        if let path = documentDirectoryPath() {
            //2. 백업하고자 하는 파일 확인
            //이미지 같은 경우 백업 편의성을 위해 폴더를 생성하고, 폴더 내에 이미지를 저장하는 것이 효율적이다.
            let realm = (path as NSString).appendingPathComponent("default.realm")
            //3. 백업하고자 하는 파일의 존재여부 확인
            if FileManager.default.fileExists(atPath: realm) {
                //5. URL배열에 백업 파일 URL 추가
                urlPaths.append(URL(string: realm)!)
            } else {
                print("백업할 파일이 없습니다.")
            }
        }
        
        //6. 백업 4번 배열에 대해 압축파일 만들기
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "archive") // Zip
            print("압축 경로: \(zipFilePath)")
            presentActivityViewController()
        }
        catch {
          print("Something went wrong")
        }
        
    }
    
    @IBAction func activityViewControllerButtonClicked(_ sender: UIButton) {
        presentActivityViewController()
    }
    
    @IBAction func restoreButtonClicked(_ sender: UIButton) {
        
        //1. 파일 앱 열기 + 확장자 지정하기
        let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypeArchive as String], in: .import)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false // true로 변경하면 여러개 선택 가능
        self.present(documentPicker, animated: true, completion: nil)
    }
}


extension SettingViewController: UIDocumentPickerDelegate {
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(#function)
        
        // 복구 -2. 선택한 파일에 대한 경로 가져오기
        guard let selectdeFileURL = urls.first else { return }
        
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let sandboxFileURL = directory.appendingPathComponent(selectdeFileURL.lastPathComponent)
        
        // 복구 -3. 압축 해제
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            
            do {
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("archive.zip")
                
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                    //복구가 완료되었습니다 메시지, 얼럿
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                })
                
            } catch {
                print("ERROR")
            }
            
        } else {
            // 파일 앱의 zip -> 도큐먼트 폴더에 복사
            do {
                try FileManager.default.copyItem(at: selectdeFileURL, to: sandboxFileURL)
                
                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fileURL = documentDirectory.appendingPathComponent("archive.zip")
                
                try Zip.unzipFile(fileURL, destination: documentDirectory, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                    //복구가 완료되었습니다 메시지, 얼럿
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                })
            } catch {
                print("ERROR")
            }
        }
    }
    
    
}
