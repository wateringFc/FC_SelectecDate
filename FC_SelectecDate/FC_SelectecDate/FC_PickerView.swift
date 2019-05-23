//
//  FC_PickerView.swift
//  Circle
//
//  Created by FC on 2019/5/22.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

/// 屏幕宽
let kScreenWidth = UIScreen.main.bounds.size.width
/// 屏幕高
let kScreenHeight = UIScreen.main.bounds.size.height
/// 宽度比
let kScalWidth = (kScreenWidth / 375)
/// 高度比
let kScalHeight = (kScreenHeight / 667)

public enum PickerViewType {
    case date // 显示【年、月、日】
    case year_month // 显示【年、月】
}

protocol PickerDelegate {
    /// 代理回调选中的日期
    func selectedDate(pickerView : FC_PickerView, dateStr : String)
}

class FC_PickerView: UIView {
    /// 代理
    var pickerDelegate : PickerDelegate?
    /// 选择器高度
    private let pickerH : CGFloat! = 260 * kScalHeight
    /// 时间选择器的类型
    private var pickerType: PickerViewType?
    /// 年月日时间选择器
    private var datePicker: UIDatePicker = UIDatePicker()
    /// 选中的年份
    private var selectedYear: String?
    /// 选中的月份
    private var selectecMonth: String?
    /// 当前选中年
    private var currentYear: Int?
    /// 当前选中月
    private var currentMonth: Int?
    
    /// 年份数组
    fileprivate lazy var yearArray: NSMutableArray = NSMutableArray()
    /// 月份数组
    fileprivate lazy var monthArray: NSMutableArray = NSMutableArray()
    /// 按钮背景视图(工具条)
    fileprivate lazy var butBgView: UIView = {
        let butBgView = UIView(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
        butBgView.backgroundColor = UIColor.lightGray
        return butBgView
    }()
    
    /// 背景大按钮
    fileprivate lazy var bgButton : UIButton = {
        let bgButton = UIButton.init(type: .system)
        bgButton.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        bgButton.addTarget(self, action: #selector(cancelButtonClick), for: UIControlEvents.touchUpInside)
        return bgButton
    }()
    
    // 取消按钮
    fileprivate lazy var cancelButton: UIButton = {
        let cancelButton = UIButton.init(type: UIButtonType.custom)
        cancelButton.frame = CGRect.init(x: 0, y: 0, width: 60, height: 44)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelButton.setTitle("取 消", for: UIControlState.normal)
        cancelButton.setTitleColor(.blue, for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: UIControlEvents.touchUpInside)
        return cancelButton
    }()
    
    // 确定按钮
    fileprivate lazy var doneButton: UIButton = {
        let doneButton = UIButton.init(type: UIButtonType.custom)
        doneButton.frame = CGRect.init(x: kScreenWidth - 60, y: 0, width: 60, height: 44)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        doneButton.setTitle("确 定", for: UIControlState.normal)
        doneButton.setTitleColor(.red, for: UIControlState.normal)
        doneButton.addTarget(self, action: #selector(doneButtonClick), for: UIControlEvents.touchUpInside)
        return doneButton
    }()
    
    
    /// 初始化
    /// - Parameter type: 选择类型
    init(type: PickerViewType) {
        super.init(frame: CGRect.init(x: 0, y: kScreenHeight, width: kScreenWidth, height: kScreenHeight))
        
        addSubview(butBgView)
        addSubview(cancelButton)
        addSubview(doneButton)
        
        pickerType = type
        
        switch type {
        case .date:
            setDateView()
            break
        case .year_month:
            setYearAndMonthView()
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 场景一
extension FC_PickerView {
    
    /// 设置【年月日】视图
    fileprivate func setDateView() {
        datePicker = UIDatePicker.init(frame: CGRect.init(x: 0, y: 44, width: kScreenWidth, height: pickerH - 44))
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.locale = Locale.init(identifier: "zh_CN")
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(FC_PickerView.dateSelected(_:)), for: UIControlEvents.valueChanged)
        datePicker.setDate(Date(), animated: true)
        self.addSubview(datePicker)
    }
}

// MARK: - 场景二
extension FC_PickerView {
    
    /// 设置【年月】视图
    fileprivate func setYearAndMonthView() {
        getCurrentDate()
        setYearArray()
        setMonthArray()
        basisSetup()
    }
    
    /// 基础UI设置
    fileprivate func basisSetup() {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 44, width: kScreenWidth, height: pickerH - 44))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        pickerView.selectRow(Int(selectedYear!)! - 1970, inComponent: 0, animated: true)
        pickerView.selectRow(Int(selectecMonth!)! - 1, inComponent: 1, animated: true)
        addSubview(pickerView)
    }
    
    /// 获取当前日期
    fileprivate func getCurrentDate() {
        let date = NSDate()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM"
        let strNowTime = timeFormatter.string(from: date as Date) as String
        let strArr = strNowTime.components(separatedBy: "-")
        if strArr.count == 2 {
            currentYear = Int(strArr[0])
            currentMonth = Int(strArr[1])
        }
        selectedYear = currentYear?.description
        selectecMonth = currentMonth?.description
    }
    
    /// 获取年数组
    fileprivate func setYearArray() {
        for i in 1970...currentYear! {
            let yearStr = "\(i)年"
            yearArray.add(yearStr)
        }
        // 年的列表末尾加“至今”
//        yearArray.add("至今")
    }
    
    /// 获取月数组
    fileprivate func setMonthArray() {
        // 清空月份数组，防止重复添加
        monthArray.removeAllObjects()
        // 如果选中的年 等于 当前年
        if Int(selectedYear!) == Int(currentYear!) {
            for i in 1...currentMonth! {
                let monthStr = "\(i)月"
                monthArray.add(monthStr)
            }
        }else {
            for i in 1...12 {
                let monthStr = "\(i)月"
                monthArray.add(monthStr)
            }
        }
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension FC_PickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    // 显示2列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // 每列显示个数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? yearArray.count : monthArray.count
    }
    
    // 内容显示
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? yearArray[row] as! String : monthArray[row] as! String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            // 取到选择的年：2019年
            let str = yearArray[row] as? String
            // 截取
            selectedYear = "\(str!.prefix(4))"
            // 重新获取月份
            setMonthArray()
            selectecMonth = currentMonth?.description
            // 刷新月份列
            pickerView.reloadComponent(1)
        
        }else if selectedYear == "至今" {
//            monthArray.removeAllObjects()
//            selectecMonth = ""
            
        }else {
            selectecMonth = monthArray[row] as? String
        }
    }
    
}

// MARK: - 事件响应
extension FC_PickerView {
    
    /// 时间选择
    @objc func dateSelected(_ datePicker: UIDatePicker) { }
    
    /// 取消按钮点击
    @objc func cancelButtonClick(){
        pickerViewHidden()
    }
    
    /// 确定按钮点击 回调当前选中日期
    @objc func doneButtonClick() {
        if pickerType == .date{
            pickerDelegate?.selectedDate(pickerView: self, dateStr: String(datePicker.date.description.prefix(10)))
        }else{
            if selectecMonth!.hasSuffix("月") {
                selectecMonth = String(selectecMonth!.prefix(selectecMonth!.count - 1))
            }
            let dateStr = selectedYear! + "-" + selectecMonth!
            pickerDelegate?.selectedDate(pickerView: self, dateStr: dateStr)
        }
        pickerViewHidden()
    }
    
    /// 展示pickerView
    public func pickerViewShow() {
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(bgButton)
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.4, animations: {
            self.bgButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.frame.origin.y = kScreenHeight - self.pickerH
        }) { (complete: Bool) in

        }
    }
    
    /// 隐藏pickerView
    fileprivate func pickerViewHidden() {
        UIView.animate(withDuration: 0.4, animations: {
            self.bgButton.backgroundColor = UIColor.clear
            self.frame.origin.y = kScreenHeight
        }) { (complete:Bool) in
            self.removeFromSuperview()
            self.bgButton.removeFromSuperview()
        }
    }
}
