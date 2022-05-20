//
//  HomeTableViewCell.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/19.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var data: [String] = []  {
        didSet{
            collectionView.reloadData()
            categoryLabel.text = "\(data.count)개"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        
        categoryLabel.backgroundColor = .blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.CustomCell.HomeCollectionViewCell, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView.tag == 0 {
            cell.imageView.backgroundColor = .brown
        } else {
            cell.imageView.backgroundColor = .magenta
        }
        
        let item = data // -> ["a", "b", "c"]
        
        cell.contentLabel.text = item[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        //테이블뷰 셀의 인덱스 패스를 어떻게 가지고 와야 할까?
        //각각의 테이블뷰 셀에 tag기능을 활용하면 가져올 수 잇다.
        if collectionView.tag == 0 {
            return CGSize(width: UIScreen.main.bounds.width, height: 100)
        } else {
            return CGSize(width: 150, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView.tag == 0 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.tag == 0 ? 0 : 10
    }
    
}
