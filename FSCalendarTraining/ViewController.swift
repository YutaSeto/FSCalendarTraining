//
//  ViewController.swift
//  FSCalendarTraining
//
//  Created by setoon on 2023/05/14.
//

import UIKit
import FSCalendar
import SwiftMoment
import CalculateCalendarLogic

class ViewController: UIViewController {
    
    let holiday = CalculateCalendarLogic()
    var holidayArray:[Date] = []
    var startOfMonth: Moment = moment()
    var endOfMonth: Moment = moment()

    @IBOutlet weak var calendarView: FSCalendar!
    
    var onliDayDateFormatter:DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d日"
        return dateFormatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setstartOfMonthAndendOfMoth()
        calendarView.dataSource = self
        calendarView.delegate = self
        calendarView.collectionView.register(UINib(nibName: "FSCalendarCustomCell", bundle: nil),forCellWithReuseIdentifier: "FSCalendarCustomCell")
    }
    
    func judgementHoliday(date:Date){
        let intYear = moment(date).year
        let intMonth = moment(date).month
        let intDay = moment(date).day
        func judgeHoliday(year:Int,month:Int,day:Int){
            let result = holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
            if result == true{
                let date = Calendar.current.date(from: DateComponents(year: intYear, month: intMonth, day: intDay))
                if let date = date {
                    holidayArray.append(date)
                }
            }
        }
        judgeHoliday(year: intYear, month: intMonth, day: intDay)
    }
    
    func setstartOfMonthAndendOfMoth(){
        //今月の1日を取得
        let calendar = Calendar.current
        let year = moment(Date()).year
        let month = moment(Date()).month
        let firstDay = calendar.date(from:DateComponents(year: year,month:month,day: 1))!
        startOfMonth = moment(firstDay)
        
        //翌月の1日を取得
        let endDay = calendar.date(byAdding: DateComponents(month: 1), to: firstDay)!
        endOfMonth = moment(endDay)
        print(endOfMonth)
    }
}


extension ViewController:FSCalendarDataSource,FSCalendarDelegate,FSCalendarDelegateAppearance{
    
    //選択した日付を青から透明に変えるコード
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor.clear
    }

    //選択した日付を透明にするコード
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        return .clear
    }

    //今日の日付の背景を赤から透明に変えるコード
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor?{
        return UIColor.clear
    }

//    その他の日付を透明、上部の日曜日は赤・土曜日は青・平日は黒にするコード
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        calendar.calendarWeekdayView.weekdayLabels[1].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[2].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[3].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[4].textColor = .black
        calendar.calendarWeekdayView.weekdayLabels[5].textColor = .black
        return UIColor.clear
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "FSCalendarCustomCell", for: date, at: position) as! FSCalendarCustomCell
        cell.dayLabel.text = onliDayDateFormatter.string(from: date)
        
        judgementHoliday(date: moment(date).date)
        
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        if moment(date) < startOfMonth || moment(date) > endOfMonth{//今月以外
            cell.dayLabel.textColor = UIColor.gray
        }else if holidayArray.contains(moment(date).date){//祝日を赤
            cell.dayLabel.textColor = .red
        }else if weekday == 7{//土曜日を青
            cell.dayLabel.textColor = UIColor.blue
        }else if weekday == 1{//日曜日を赤
            cell.dayLabel.textColor = UIColor.red
        }else{//上記以外の日を黒
            cell.dayLabel.textColor = UIColor.black
        }
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //カスタムセルの枠の色を全てdeselect()で実行している色に変更
        calendar.visibleCells()
            .map{$0 as? FSCalendarCustomCell}
            .compactMap{$0}
            .filter{$0._isSelected}
            .forEach{ customCell in
                customCell.deselect()
            }
        
        //タップされたcellの枠の色を変更
        if let cell = calendar.cell(for:date, at: monthPosition) as? FSCalendarCustomCell{
            cell.select()
        }
    }
}
