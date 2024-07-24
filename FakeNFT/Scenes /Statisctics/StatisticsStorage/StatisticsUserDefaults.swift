import Foundation

final class StatisticsUserDefaults {
    
    private let userDefaults = UserDefaults.standard
    
    var sortingWay: String? {
        get {
            userDefaults.string(forKey: "sortingWay")
        }
        set {
            userDefaults.set(newValue, forKey: "sortingWay")
        }
    }
}
