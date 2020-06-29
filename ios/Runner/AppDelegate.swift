import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller : FlutterViewController = self.window.rootViewController as! FlutterViewController
    
    let batteryChannel: FlutterMethodChannel = FlutterMethodChannel(name: "EnglishChannel", binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler { (call, result) in
        if call.method == "isGrassGreenerOnTheOtherSide"  {
            result(isGrassGreenerOnTheOtherSide())
        }else {
            result(FlutterMethodNotImplemented);
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

func isGrassGreenerOnTheOtherSide() -> String {
    return "Not in a black and white movie"
}
