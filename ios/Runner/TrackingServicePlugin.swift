import Flutter
import UIKit
import CoreLocation
import BackgroundTasks

@objc public class TrackingServicePlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    private var methodChannel: FlutterMethodChannel?
    private var locationManager: CLLocationManager?
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    
    // MARK: - Flutter Plugin Registration
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "com.example.going50/tracking_service", binaryMessenger: registrar.messenger())
        let instance = TrackingServicePlugin()
        instance.methodChannel = channel
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    // MARK: - Method Channel Handler
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startBackgroundTask":
            startBackgroundTask(result: result)
        case "stopService":
            stopBackgroundTask(result: result)
        case "isServiceRunning":
            result(backgroundTaskIdentifier != .invalid || locationManager != nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // MARK: - Background Task Management
    
    private func startBackgroundTask(result: @escaping FlutterResult) {
        // Initialize location manager if not already initialized
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.allowsBackgroundLocationUpdates = true
            locationManager?.pausesLocationUpdatesAutomatically = false
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.distanceFilter = 10.0 // Update every 10 meters
            locationManager?.activityType = .automotiveNavigation
        }
        
        // Request permission if needed
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            result(FlutterError(code: "PERMISSION_DENIED",
                                message: "Location permission denied",
                                details: nil))
            return
        }
        
        // Start background task
        backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask { [weak self] in
            // Clean up when background task expires
            self?.endBackgroundTask()
        }
        
        // Start location updates
        locationManager?.startUpdatingLocation()
        
        // Notify Flutter that service started
        methodChannel?.invokeMethod("onServiceStarted", arguments: nil)
        
        result(true)
    }
    
    private func stopBackgroundTask(result: @escaping FlutterResult) {
        // Stop location updates
        locationManager?.stopUpdatingLocation()
        
        // End background task
        endBackgroundTask()
        
        // Notify Flutter that service stopped
        methodChannel?.invokeMethod("onServiceStopped", arguments: nil)
        
        result(true)
    }
    
    private func endBackgroundTask() {
        if backgroundTaskIdentifier != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskIdentifier)
            backgroundTaskIdentifier = .invalid
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Send location data to Flutter via method channel
        if let location = locations.last {
            let locationData: [String: Any] = [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude,
                "altitude": location.altitude,
                "speed": location.speed,
                "course": location.course,
                "timestamp": location.timestamp.timeIntervalSince1970 * 1000,
                "accuracy": location.horizontalAccuracy
            ]
            
            methodChannel?.invokeMethod("locationUpdate", arguments: locationData)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            stopBackgroundTask { _ in }
        }
    }
    
    // MARK: - Application Delegate Methods
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        // Keep the location manager running when app goes to background
        if locationManager != nil {
            print("App entered background, keeping location services running")
        }
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        // Clean up when app is terminating
        endBackgroundTask()
    }
} 