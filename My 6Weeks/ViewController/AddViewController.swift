//
//  AddViewController.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/14.
//

import UIKit

class AddViewController: UIViewController {
    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var diaryTitleTextField: UITextField!
    @IBOutlet weak var diaryDateButton: UIButton!
    
    @IBOutlet weak var diaryContentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initNavigationItem()
    }
    
    func initNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonClicked))
    }
    
    @objc func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }


}
