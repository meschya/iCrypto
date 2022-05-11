import Charts
import UIKit

final class CryptoBarChartView: UIView {
    // MARK: - Properties
    
    // MARK: Private
    
    private let chartView: BarChartView = .init()
    
    struct ViewModel {
        let data: [Double]
        let showLegend: Bool
        let showAxis: Bool
        let fillColor: UIColor
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addSetups()
        configure()
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chartView.frame = bounds
    }
    
    // MARK: - API
    
    func configure() {
        var entries = [BarChartDataEntry]()
        for x in 0 ..< 10 {
            entries.append(BarChartDataEntry(
                x: Double(x),
                y: Double.random(in: 0 ... 3)))
        }
//        let xAxis = chartView.xAxis
//        let rightAxis = chartView.rightAxis
//        let legend = chartView.legend
        let set = BarChartDataSet(entries: entries, label: "Cost")
        set.colors = ChartColorTemplates.colorful()
        let data = BarChartData(dataSet: set)
        chartView.data = data
        chartView.center = center
        chartView.rightAxis.enabled = true
        chartView.legend.enabled = true
    }
    
    // MARK: - Setups
    
    // MARK: Private
    
    private func addSubviews() {
        addSubview(chartView)
    }
    
    private func addSetups() {
        chartView.setScaleEnabled(true)
        chartView.xAxis.enabled = false
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.drawGridBackgroundEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.legend.enabled = false
    }
}
