import Flutter
import UIKit

public class SwiftChannelObserverOfKitPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "channel_observer_of_kit", binaryMessenger: registrar.messenger())
    let instance = SwiftChannelObserverOfKitPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
