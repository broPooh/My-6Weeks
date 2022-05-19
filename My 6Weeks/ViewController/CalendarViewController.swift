//
//  CalendarViewController.swift
//  My 6Weeks
//
//  Created by bro on 2022/05/19.
//

import UIKit
import FSCalendar
import RealmSwift

class CalendarViewController: UIViewController {

    @IBOutlet weak var calendarView: FSCalendar!
    
    let localRealm = try! Realm()
    
    var tasks: Results<UserDiary>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        
        tasks = localRealm.objects(UserDiary.self)
    }


}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 달력의 날짜를 선택했을 때 실행되는 코드를 이곳에서 작성할 수 있다.
    }
        
    //Date: 시분초까지 동일해야 한다.
    //1. 영국 표준시 기준으로 표기
    //2. 데이트 포맷터로 원하는 형태로 만들어서 저장하기.
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
//        let format = DateFormatter()
//        format.dateFormat = "yyyyMMdd"
//        let test = "20220516"
//
//        if format.date(from: test) == date {
//            return 3
//        } else {
//            return 1
//        }
        
        
        //5월 3일 3개의 일기라면 3개를, 없다면 x, 1개면 1개
        return tasks.filter("writeDate == %@", date).count
        
    }
    
}


