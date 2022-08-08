//
//  CoinManager.swift
//  BTCKur
//
//  Created by Barış Yeşilkaya on 8.08.2022.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apikey = "5E59292A-0708-4D32-B410-25787EE86E6D"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apikey)"

        //1.Create a Url
        if let url = URL(string: urlString) {
            
            //2.Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3.Give URLSession a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJson(coinData: safeData) {
                        let coinPrice = String(format: "%.2f", coin)
                        self.delegate?.didUpdateCoin(price: coinPrice, currency: currency)
                    }
                }
            }
            
            //4.Start the task
            task.resume()
            
        }
    }
    
    func parseJson(coinData: Data) -> Double? {
        
        let decoder = JSONDecoder()
        
        do {
            let decodeDate = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodeDate.rate
            return rate
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
    
}
