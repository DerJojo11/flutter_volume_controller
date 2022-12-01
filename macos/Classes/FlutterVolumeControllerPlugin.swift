import Cocoa
import FlutterMacOS

public class FlutterVolumeControllerPlugin: NSObject, FlutterPlugin {
    private static let volumeController: VolumeController = VolumeController()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(
            name: "com.yosemiteyss.flutter_volume_controller/method",
            binaryMessenger: registrar.messenger
        )
        let eventChannel = FlutterEventChannel(
            name: "com.yosemiteyss.flutter_volume_controller/event",
            binaryMessenger: registrar.messenger
        )
        
        let instance = FlutterVolumeControllerPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        
        let listener = VolumeListener(volumeController: volumeController)
        eventChannel.setStreamHandler(listener)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case MethodName.getVolume:
            do {
                result(try FlutterVolumeControllerPlugin.volumeController.getVolume())
            } catch {
                result(FlutterError(code: ErrorCode.default, message: ErrorMessage.getVolume, details: error.localizedDescription))
            }
        case MethodName.setVolume:
            do {
                let args = call.arguments as! [String: Any]
                let volume = Float(args[MethodArg.volume] as! Double)
                try FlutterVolumeControllerPlugin.volumeController.setVolume(volume)
            } catch {
                result(FlutterError(code: ErrorCode.default, message: ErrorMessage.setVolume, details: nil))
            }
        case MethodName.raiseVolume:
            let args = call.arguments as! [String: Any]
            let step = args[MethodArg.step] as? Float
            FlutterVolumeControllerPlugin.volumeController.raiseVolume(step)
        case MethodName.lowerVolume:
            let args = call.arguments as! [String: Any]
            let step = args[MethodArg.step] as? Float
            FlutterVolumeControllerPlugin.volumeController.lowerVolume(step)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
