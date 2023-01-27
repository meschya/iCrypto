import Foundation
import UIKit

protocol ModuleBuilderProtocol {
    static func createMainModule() -> UIViewController
    static func createHomeModule() -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    static func createMainModule() -> UIViewController {
        let view = MainTabBarController()
        let networkManager = NetworkManager()
        let presenter = MainPresenter(view: view, networkManager: networkManager)
        view.presenter = presenter
        return view
    }
    
    static func createHomeModule() -> UIViewController {
        let view = HomeViewController()
        let networkManager = NetworkManager()
        let presenter = HomePresenter(view: view, networkManager: networkManager)
        view.presenter = presenter
        return view
    }
}
