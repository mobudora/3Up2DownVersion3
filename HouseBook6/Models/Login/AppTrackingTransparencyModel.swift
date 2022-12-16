//
//  AppTrackingTransparencyModel.swift
//  HouseBook6
//
//  Created by ドラ on 2022/09/27.
//

import AppTrackingTransparency

class AppTrackingTransparencyModel {
    public func requestTracking() {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            switch status {
            case .authorized:
                print("OK")
            case .denied, .restricted, .notDetermined:
                print("だめでした。")
            @unknown default:
                fatalError()
            }
        })
    }
}
