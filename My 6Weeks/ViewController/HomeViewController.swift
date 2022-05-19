//
//  HomeViewController.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/14.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    let array = [
        Array(repeating: "a", count: 20),
        Array(repeating: "b", count: 15),
        Array(repeating: "c", count: 10),
        Array(repeating: "d", count: 5),
        Array(repeating: "e", count: 20),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()
        homeTableView.delegate = self
        homeTableView.dataSource = self

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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Const.CustomCell.HomeTableViewCell, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.categoryLabel.text = "\(array[indexPath.row])"
        
        cell.categoryLabel.backgroundColor = .yellow
        cell.collectionView.backgroundColor = .lightGray
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        
        // cell 파일에서 처리 해보기
        cell.data = array[indexPath.row] // 데이터 넘겨주기
        
        //각각의 테이블뷰셀에서 tag기능을 활용해 indexPath를 넘긴다
        //이렇게 태그를 통해서 indexPath를 넘기면 컬렉션뷰에서 받아서 사용할 수 있다.
        //하나의 섹션인 경우에만 사용이 가능한 방법이다...
        cell.collectionView.tag = indexPath.row
        cell.collectionView.isPagingEnabled = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 1 ? 300 : 170
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.CustomCell.HomeCollectionViewCell, for: indexPath) as? HomeCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.backgroundColor = .brown
        
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
