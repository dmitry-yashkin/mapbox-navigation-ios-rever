import UIKit
import MapboxCoreNavigation

/**
 An object that notifies a map view when the user’s location changes, minimizing the noise that normally accompanies location updates from a `CLLocationManager` object.
 
 Unlike `Router` classes such as `RouteController` and `LegacyRouteController`, this class operates without a predefined route, matching the user’s location to the road network at large. If your application displays an `MGLMapView` before starting turn-by-turn navigation, set `MGLMapView.locationManager` to an instance of this class so that the map view always shows the location snapped to the road network. For example, use this class to show the user’s current location as they wander around town.
 
 This class depends on `PassiveLocationDataSource` to detect the user’s location as it changes. If you want location updates but do not need to display them on a map and do not want a dependency on the MapboxNavigation module, you can use `PassiveLocationDataSource` instead of this class.
 */
// TODO: Port `MGLLocationManager` functionality.
open class PassiveLocationManager: NSObject {
    /**
     Initializes the location manager with the given data source.
     
     - parameter dataSource: A data source that detects the user’s location as it changes.
     */
    public init(dataSource: PassiveLocationDataSource) {
        self.dataSource = dataSource
        super.init()
        dataSource.delegate = self
    }
    
    /**
     The location manager’s data source, which detects the user’s location as it changes.
     */
    public let dataSource: PassiveLocationDataSource

    public var authorizationStatus: CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }

    public func requestAlwaysAuthorization() {
        dataSource.systemLocationManager.requestAlwaysAuthorization()
    }

    public func requestWhenInUseAuthorization() {
        dataSource.systemLocationManager.requestWhenInUseAuthorization()
    }
    
    @available(iOS 14.0, *)
    public func accuracyAuthorization() -> MBNavigationAccuracyAuthorization {
        // CLLocationManager.accuracyAuthorization was introduced in the iOS 14 SDK in Xcode 12, so Xcode 11 doesn’t recognize it.
        guard let accuracyAuthorizationValue = dataSource.systemLocationManager.value(forKey: "accuracyAuthorization") as? Int,
              let accuracyAuthorization = MBNavigationAccuracyAuthorization(rawValue: accuracyAuthorizationValue) else {
            return .fullAccuracy
        }
        return accuracyAuthorization
    }
    
    @available(iOS 14.0, *)
    public func requestTemporaryFullAccuracyAuthorization(withPurposeKey purposeKey: String) {
        // CLLocationManager.requestTemporaryFullAccuracyAuthorization(withPurposeKey:) was introduced in the iOS 14 SDK in Xcode 12, so Xcode 11 doesn’t recognize it.
        let requestTemporaryFullAccuracyAuthorization = Selector(("requestTemporaryFullAccuracyAuthorizationWithPurposeKey:" as NSString) as String)
        guard dataSource.systemLocationManager.responds(to: requestTemporaryFullAccuracyAuthorization) else {
            return
        }
        dataSource.systemLocationManager.perform(requestTemporaryFullAccuracyAuthorization, with: purposeKey)
    }

    public func startUpdatingLocation() {
        dataSource.startUpdatingLocation { (error) in

        }
    }

    public func stopUpdatingLocation() {
        dataSource.systemLocationManager.stopUpdatingLocation()
    }

    public var headingOrientation: CLDeviceOrientation {
        get {
            dataSource.systemLocationManager.headingOrientation
        }
        set {
            dataSource.systemLocationManager.headingOrientation = newValue
        }
    }

    public func startUpdatingHeading() {
        dataSource.systemLocationManager.startUpdatingHeading()
    }

    public func stopUpdatingHeading() {
        dataSource.systemLocationManager.stopUpdatingHeading()
    }

    public func dismissHeadingCalibrationDisplay() {
        dataSource.systemLocationManager.dismissHeadingCalibrationDisplay()
    }
}

extension PassiveLocationManager: PassiveLocationDataSourceDelegate {
    @available(iOS 14.0, *)
    public func passiveLocationDataSourceDidChangeAuthorization(_ dataSource: PassiveLocationDataSource) {

    }
    
    public func passiveLocationDataSource(_ dataSource: PassiveLocationDataSource, didUpdateLocation location: CLLocation, rawLocation: CLLocation) {
    
    }
    
    public func passiveLocationDataSource(_ dataSource: PassiveLocationDataSource, didUpdateHeading newHeading: CLHeading) {
    
    }
    
    public func passiveLocationDataSource(_ dataSource: PassiveLocationDataSource, didFailWithError error: Error) {

    }
}
