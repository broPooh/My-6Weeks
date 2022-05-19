//
//  SearchTableViewCell.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/15.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    let formatter = DateFormatter()

    @IBOutlet weak var diaryImageView: UIImageView!
    @IBOutlet weak var diaryTitleLabel: UILabel!
    @IBOutlet weak var diaryDateLabel: UILabel!
    @IBOutlet weak var diaryContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        formatter.dateFormat = "yyyy년 MM월 dd일"
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
    
    func configureCell(diary: UserDiary) {
        diaryTitleLabel.text = diary.title
        diaryContentLabel.text = diary.content
        diaryDateLabel.text = formatter.string(from: diary.writeDate)
        diaryImageView.image = loadImageFromDocumentDirectory(imageName: "\(diary._id).png")
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
    
}
