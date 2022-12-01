//
//  VolumeListener.swift
//  flutter_volume_controller
//
//  Created by yosemiteyss on 18/9/2022.
//

import Foundation
import AVFoundation

class VolumeListener: NSObject, FlutterStreamHandler {
    private let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
    private var outputVolumeObservation: NSKeyValueObservation?
    
    var isListening: Bool {
        get {
            return outputVolumeObservation != nil
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        do {
            let args = arguments as! [String: Any]
            let emitOnStart = args[MethodArg.emitOnStart] as! Bool
            
            try audioSession.setActive(true)
            
            outputVolumeObservation = audioSession.observe(\.outputVolume) { session, _ in
                events(session.outputVolume)
            }
            
            if emitOnStart {
                events(try audioSession.getVolume())
            }
        } catch {
            return FlutterError(
                code: ErrorCode.default,
                message: ErrorMessage.registerListener,
                details: error.localizedDescription
            )
        }
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        outputVolumeObservation = nil
        return nil
    }
}
