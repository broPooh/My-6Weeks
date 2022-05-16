//
//  HomeViewController.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/14.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()

    }
    
    
    func initNavigation() {
        title = "HOME"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(presentShow))
    }
    
    @objc func presentShow() {
        //1. 스토리보드 특정
        let storyboard = UIStoryboard(name: "Content", bundle: nil)
        
        //2. 스토리보드 내 많은 뷰 컨트롤러 중, 전환하고자 하는 뷰 컨트롤러 가져오기
        let vc = storyboard.instantiateViewController(withIdentifier: Const.ViewController.AddViewController) as! AddViewController
        
        //2-1 네비게이션 컨트롤러 임베드
        let nav = UINavigationController(rootViewController:  vc)
        
        nav.modalPresentationStyle = .fullScreen
        
        //3. Present
        self.present(nav, animated: true, completion: nil)
    }

}
