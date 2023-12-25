import Foundation
import Reachability

public func checkInternetConnection() -> Bool {
    guard let reachability = try? Reachability(hostname: "https://polcom.de") else {
        print("Unable to create Reachability object.")
        return false
    }

    switch reachability.connection {
    case .wifi, .cellular:
        if reachability.connection == .unavailable {
            Console2.shared.log("Connected to WiFi/Cellular, but unable to connect to the polcom.de")
            return false
        } else {
            return true
        }
    case .unavailable, .none:
        Console2.shared.log("Please enable ")
    }
    return false
}
