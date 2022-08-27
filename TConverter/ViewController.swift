//
//  ViewController.swift
//  TConverter
//
//  Created by Виктор Борисовский on 25.08.2022.
//

import UIKit

enum TemperatureTypes : String, CaseIterable {
    case celsius = "C"
    case fahrenheit = "F"
    case kelvin = "K"
}


func convertTemperature(fromType: TemperatureTypes, toType: TemperatureTypes, value: Int) -> Int {
    let tuple = (fromType, toType)
    let value = Double(value)
    
    var convertedValue: Int
    switch tuple {
        case ((.celsius, .celsius)):
            fallthrough
        case ((.fahrenheit, .fahrenheit)):
            fallthrough
        case ((.kelvin, .kelvin)):
            convertedValue = Int(value)
        case ((.celsius, .fahrenheit)):
            convertedValue = Int(round(value * 1.8 + 32))
        case ((.celsius, .kelvin)):
            convertedValue = Int(round(value + 273.15))
        case ((.fahrenheit, .celsius)):
            convertedValue = Int(round((32 - value) * 5 / 9))
        case ((.fahrenheit, .kelvin)):
            convertedValue = Int(round((32 - value) * 5 / 9 + 273.15))
        case ((.kelvin, .celsius)):
            convertedValue = Int(round(value - 273.15))
        case ((.kelvin, .fahrenheit)):
            convertedValue = Int(round((value - 273.15) * 1.8 + 32))
    }
    
    return convertedValue
}

class ViewController: UIViewController {
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var convertedLabel: UILabel!
    
    @IBOutlet weak var originPicker: UIPickerView! {
        didSet {
            originPicker.delegate = self
            originPicker.dataSource = self
        }
    }
    
    @IBOutlet weak var convertedPicker: UIPickerView! {
        didSet {
            convertedPicker.delegate = self
            convertedPicker.dataSource = self
        }
    }
    
    @IBOutlet weak var slider: UISlider! {
        didSet {
            slider.maximumValue = 500
            slider.minimumValue = -500
            slider.value = 0
        }
    }
    
    var pickersData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        pickersData = TemperatureTypes.allCases.map({$0.rawValue})

        convertedPicker.selectRow(1, inComponent: 0, animated: false)
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let originTemperatureType = TemperatureTypes.init(rawValue: pickersData[originPicker.selectedRow(inComponent: 0)])
        let convertedTemperatureType = TemperatureTypes.init(rawValue: pickersData[convertedPicker.selectedRow(inComponent: 0)])
        let originValue = Int(round(sender.value))
        let convertedValue = convertTemperature(fromType: originTemperatureType!, toType: convertedTemperatureType!, value: originValue)

        originLabel.text = "\(originValue)º"
        convertedLabel.text = "\(convertedValue)º"
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickersData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickersData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let originTemperatureType = TemperatureTypes.init(rawValue: pickersData[originPicker.selectedRow(inComponent: 0)])
        let convertedTemperatureType = TemperatureTypes.init(rawValue: pickersData[convertedPicker.selectedRow(inComponent: 0)])
        let originValue = Int(originLabel.text!.dropLast(1))!
        let convertedValue = convertTemperature(fromType: originTemperatureType!, toType: convertedTemperatureType!, value: originValue)
        
        convertedLabel.text = "\(convertedValue)º"
    }
}
