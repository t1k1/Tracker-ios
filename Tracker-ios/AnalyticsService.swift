//
//  AnalyticsService.swift
//  Tracker-ios
//
//  Created by Aleksey Kolesnikov on 24.11.2023.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        let apiKey = "1203868b-203c-47e5-8932-d300094fafd1"
        guard let configuration = YMMYandexMetricaConfiguration.init(apiKey: apiKey) else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
   
    func reportEvent() {
        let params : [AnyHashable : Any] = ["key1": "value1", "key2": "value2"]
        YMMYandexMetrica.reportEvent("EVENT", parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
