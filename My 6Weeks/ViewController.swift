//
//  ViewController.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fontLabel1: UILabel!
    @IBOutlet weak var fontLabel2: UILabel!
    @IBOutlet weak var fontLabel3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        fontLabel1.text = LocalizableStrings.welcome_text.localized
        fontLabel1.font = UIFont().mainBlack
        
        fontLabel1.text = LocalizableStrings.data_backup.localized
        fontLabel2.font = UIFont(name: "S-CoreDream-6Bold", size: 14)
        
        //fontLabel3.text = "HELO WORLD!!! 반가워요~~"
        fontLabel3.font = UIFont(name: "S-CoreDream-4Regular", size: 14)
        fontLabel3.text = LocalizableStrings.data_restore.localizedWithTable(tableName: "Setting")
        
    }


}

