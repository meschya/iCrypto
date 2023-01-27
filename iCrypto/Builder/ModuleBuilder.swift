import Foundation
import UIKit

protocol BuilderProtocol {
    static func createMainModule() -> UIViewController
}

class Builder: BuilderProtocol {
    static func createMainModule() -> UIViewController {
        let view = MainTabBarController()
        let networkManager = NetworkManager()
        let presenter = MainPresenter(view: view, networkManager: networkManager)
        view.presenter = presenter
        return view
    }
}
