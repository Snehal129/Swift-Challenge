//
//  AppInitializationService.swift
//  GMapsNearbyMe
//
//  Created by snehal.kerkar on 29/06/17.
//  Copyright © 2017 Snehal. All rights reserved.
//

import UIKit

class AppInitializationService: NSObject, GeoJsonDownloaderDelegate {
    /**
     * The shared AppInitializationService instance.
     */
    static let sharedInstance = AppInitializationService()
    
    // MARK: Initialization
    
    override init()
    {
        super.init()
    }
    
    func initApp() {
        self.requestGeojsonData()
    }
    
    private func requestGeojsonData() {
        let geojsonDownloader = GeojsonDownloader.init(url: "https://gist.github.com/chaitanyapandit/e9142fe5d00e605faed812fcad81a77e/raw/0b2cb41dc4e09c87118f624be417c6cb9c8841f2/sf.geojson")
        geojsonDownloader.delegate = self
        geojsonDownloader.requestGeojson()
    }
    
    
    // MARK: GeoJsonDownloaderDelegate Handling
    
    func geojsonRequest(didReceive response: AnyObject) {
//        debugPrint("geojsonRequest:didReceive:\(response)")
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Constants().kUINotificationGeojsonDataReceived),
                                        object: response)
    }
}
