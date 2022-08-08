//
//  ViewController.swift
//  BTCKur
//
//  Created by Barış Yeşilkaya on 8.08.2022.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
    }

    
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { //Sütun sayısı
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //Satır sayısı
        return coinManager.currencyArray.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // String çıktısı olan, her satır için tekrar eden fonksiyon. row ile diziden satırı seçeriz.
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
        
    }
}

//MARK: - CoinnManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didUpdateCoin(price: String, currency: String) {
        DispatchQueue.main.async {
            self.valueLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}
