import UIKit

class ViewController: UIViewController, CoinManagerDeletage {
    
    
    
    @IBOutlet weak var coinRateLabel: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
    }
    
    func fetchCoin() {
        coinManager.fetchCoin(currencyName: "USD")
        print("you here")
    }
    
    func didUpdateCoin(price: String) {
        DispatchQueue.main.async {
            self.coinRateLabel.text = price
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}


