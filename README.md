# FC_SelectecDate
日期选择器，实现【年月日】、【年月】选择
// 选择器类型
```
public enum PickerViewType {
    case date // 显示【年、月、日】
    case year_month // 显示【年、月】
}
```
// 代理回调选中日期
```
protocol PickerDelegate {
    func selectedDate(pickerView : FC_PickerView, dateStr : String)
}
```
// 使用
```
let pickerView = FC_PickerView.init(type: .date)
pickerView.pickerDelegate = self
pickerView.pickerViewShow()
```
![gif](https://github.com/wateringFc/FC_SelectecDate/blob/master/image/05-23.gif)
![11](https://github.com/wateringFc/FC_SelectecDate/blob/master/image/11.png)
![22](https://github.com/wateringFc/FC_SelectecDate/blob/master/image/22.png)
