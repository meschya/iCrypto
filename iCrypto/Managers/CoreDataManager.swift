import CoreData
import UIKit

final class CoreDataManager {
    // MARK: - Properties

    // MARK: Private

    static let instance = CoreDataManager()

    // MARK: - Commands
    
    func saveInvestment(_ invest: Investment, _ symbol: String, _ name: String, _ investPrice: Double, _ targetPrice: Double, _ buyingPrice: Double) {
        var invest = invest
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            invest = Investment(context: appDelegate.persistentContainer.viewContext)
            invest.coinSymbol = symbol
            invest.coinName = name
            invest.invest = investPrice
            invest.targetPrice = targetPrice
            invest.buyingPrice = buyingPrice
            appDelegate.saveContext()
        }
    }
    
    func saveWallet(_ wallet: Wallet, _ symbol: String) {
        var wallet = wallet
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            wallet = Wallet(context: appDelegate.persistentContainer.viewContext)
            wallet.coinSymbol = symbol
            appDelegate.saveContext()
        }
    }
    
    func saveProfile(_ profile: Profile, _ name: String, _ phoneNumber: String, _ date: Date, _ image: UIImage) {
        var profile = profile
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            profile = Profile(context: appDelegate.persistentContainer.viewContext)
            profile.name = name
            profile.phoneNumber = phoneNumber
            profile.date = date
            profile.image = image.pngData()
            appDelegate.saveContext()
        }
    }
    
    private init() {}
}
