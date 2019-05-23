//
//  ViewController.swift
//  FC_SelectecDate
//
//  Created by FC on 2019/5/23.
//  Copyright © 2019年 JKB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    fileprivate lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 150, width: UIScreen.main.bounds.size.width, height: 50))
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 19)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(label)
        
        
        let arr = ["年月日", "年月"]
        for i in 0..<2 {
            let but = UIButton(frame: CGRect(x: 100, y: 300 + i*30 + i*50, width: 180, height: 50))
            but.backgroundColor = UIColor.gray
            but.setTitle(arr[i], for: .normal)
            but.addTarget(self, action: #selector(ViewController.click(but:)), for: .touchUpInside)
            but.tag = 100 + i
            view.addSubview(but)
        }
    }
    
    @objc func click(but: UIButton) {
        switch but.tag {
        case 100:
            let pickerView = FC_PickerView.init(type: .date)
            pickerView.pickerDelegate = self
            pickerView.pickerViewShow()
            
        default:
            let pickerView = FC_PickerView.init(type: .year_month)
            pickerView.pickerDelegate = self
            pickerView.pickerViewShow()
        }
    }


}

extension ViewController: PickerDelegate {
    
    func selectedDate(pickerView: FC_PickerView, dateStr: String) {
        print(dateStr)
        label.text = "当前日期：\(dateStr)"
    }
}

