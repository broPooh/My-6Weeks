//
//  SearchTableViewCell.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/15.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var diaryTitleLabel: UILabel!
    @IBOutlet weak var diaryDateLabel: UILabel!
    @IBOutlet weak var diaryContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageViewConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }
    
    func imageViewConfig() {
        diaryImageView.backgroundColor = .blue
        diaryImageView.layer.cornerRadius = 10
        diaryImageView.clipsToBounds = true
    }
    
}
