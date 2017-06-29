//
//  GeojsonDownloader.swift
//  GMapsNearbyMe
//
//  Created by snehal.kerkar on 28/06/17.
//  Copyright © 2017 Snehal. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces

protocol GeoJsonDownloaderDelegate
{
    func geojsonRequest(didReceive response: AnyObject)
}

class GeojsonDownloader: Operation {

    var url = "https://gist.github.com/chaitanyapandit/e9142fe5d00e605faed812fcad81a77e/raw/0b2cb41dc4e09c87118f624be417c6cb9c8841f2/sf.geojson"

    var delegate: GeoJsonDownloaderDelegate?
    
    init(url: String) {
        self.url = url
        super.init()
    }
    
    func requestGeojson() {
        print("requestGeojson:")
        
        Alamofire.request(self.url)
            .responseJSON { response in
                //print(response)
                
                if let json = response.result.value {
                    //print("GeoJSON: \(json)")
                    self.parseGeojson(json as AnyObject)
                }
        }
    }
    
    private func parseGeojson(_ jsonData: AnyObject) {
        var places = [Place]()
        
        if let data: NSDictionary = jsonData as? NSDictionary,
            let features = data["features"] as? [[String: Any]] {
            for feature in features {
                let place = Place()
                
                // Name
                if let properties = feature["properties"] as? [String: Any] {
                    place.name = properties["name"] as? String ?? ""
                }
                
                // Coodinates
                if let geometry = feature["geometry"] as? [String: Any] {
                    let coordinates = geometry["coordinates"] as! [[[[Double]]]]
                    place.coordinates = Array((coordinates[0]).joined())
                }
                
                places.append(place)
            }
        } else {
            print("Nil GeoJSON data found.")
        }
        
        delegate?.geojsonRequest(didReceive: places as AnyObject)
    }
}
