import CoreLocation
import UIKit

class LocationManager: NSObject {
    var authorizationStatusCallback: ((_ authorizationStatus: CLAuthorizationStatus) -> Void)?
    var locationCallback: ((_ location: CLLocation?, _ error: Error?) -> Void)?

    let locationManager: CLLocationManager

    override init() {
        self.locationManager = CLLocationManager()

        super.init()

        self.locationManager.delegate = self
        self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        authorizationStatusCallback?(status)
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }

        self.locationCallback?(location, nil)
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print("Error location: \(error.localizedDescription)")
        self.locationCallback?(nil, error)
    }

    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatusCallback?(status)
    }
}
