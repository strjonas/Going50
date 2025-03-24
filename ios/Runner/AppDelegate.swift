import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Register all plugins through the generated registrant
    GeneratedPluginRegistrant.register(with: self)
    
    // The TrackingServicePlugin is already registered by GeneratedPluginRegistrant
    // Remove the duplicate registration to avoid conflicts
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
