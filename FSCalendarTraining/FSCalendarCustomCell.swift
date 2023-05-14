//
//  FSCalendarCell.swift
//  DHAB
//
//  Created by setoon on 2023/03/28.
//


import FSCalendar

class FSCalendarCustomCell: FSCalendarCell {
    
    @IBOutlet weak var dayLabel:UILabel!
    var _isSelected = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func select(){
        _isSelected = true
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 2.0
    }
    
    func deselect(){
        _isSelected = false
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
