import UIKit

extension UIColor {
    static let theme = CustomColor()
}

// Example: UIColor.theme.accent
struct CustomColor {
    let accent = UIColor(named: "AccentColor")
    let background = UIColor(named: "BackgroundColor")
    let title = UIColor(named: "TitleColor")
    let cellColor = UIColor(named: "CellColor")
}
