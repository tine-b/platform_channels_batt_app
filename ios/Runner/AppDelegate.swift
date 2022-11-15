import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let batteryChannel = FlutterMethodChannel(name: "tine.dev/battery",
                                              binaryMessenger: controller.binaryMessenger)
    batteryChannel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      // This method is invoked on the UI thread.
      guard call.method == "getBatteryDetails" else {
        result(FlutterMethodNotImplemented)
        return
      } 

      if (call.method == "getBatteryDetails") {
        self?.getBatteryDetails(result: result)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getBatteryDetails(result: FlutterResult) {
    var status = ""
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    if device.batteryState == UIDevice.BatteryState.unknown {
      result(FlutterError(code: "UNAVAILABLE",
                          message: "Battery status unavailable",
                          details: nil))
    } else {
      switch device.batteryState {
        case UIDevice.BatteryState.unplugged:
          status = "Your phone is unplugged"
        case UIDevice.BatteryState.charging:
          status = "Your phone is charging"
        case UIDevice.BatteryState.full:
          status = "Your phone is fully-charged"
        default:
          status = "Battery status unavailable"
      }    

      result(["level": Int(device.batteryLevel * 100), "status": status])

    }
  }
   
}
