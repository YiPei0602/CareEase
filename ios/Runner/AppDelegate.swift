import UIKit
import Flutter
import GoogleMaps // <-- Add this import

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  
    GMSServices.provideAPIKey("AIzaSyDRSDyVILOIcQn-_fRBWgnfnE_sxgAbzXE") // <-- Insert your API Key here
    
    GeneratedPluginRegistrant.register(with: self)
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
