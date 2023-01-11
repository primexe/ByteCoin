
import Foundation

protocol CoinManagerDeletage {
    func didUpdateCoin(price: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "8D0E0D36-65EF-49C0-868F-34D3D0025690"
    
    var delegate: CoinManagerDeletage?

    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func fetchCoin(currencyName: String) {
       let urlString = "\(baseURL)/\(currencyName)?apikey=\(apiKey)"
        print(urlString)
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1 create a URL
        if let url = URL(string: urlString) {
            //2 create URL session
            let session = URLSession(configuration: .default)
            
            // give session a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        let coinString = String(format: "%.2f", coin)
                        self.delegate?.didUpdateCoin(price: coinString)
                    }
                }
            }
            // 4. resume
            task.resume()
        }
    }
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let currency = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coin = CoinModel(currencyName: currency, rateBTC: rate)
            return rate
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
