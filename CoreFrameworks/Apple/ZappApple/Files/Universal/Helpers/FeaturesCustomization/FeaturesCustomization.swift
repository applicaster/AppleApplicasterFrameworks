//
//  FeaturesCustomization.swift
//  ZappApple
//
//  Created by Anton Kononenko on 10/8/19.
//  Copyright © 2019 Anton Kononenko. All rights reserved.
//

import Foundation

class FeaturesCustomization {
    static var featuresCustomizationDict:[AnyHashable:Any]? = getPlist()
    
    class func getPlist() -> [AnyHashable:Any]? {
        guard let path = Bundle.main.path(forResource: DataManager.ApplicationFiles.featureCustomization,
                                          ofType: DataManager.DataKeysExtensions.plist),
            
        let data = FileManager.default.contents(atPath: path)  else {
            return nil
        }

        return (try? PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil)) as? [AnyHashable:Any]
    }
    
    class func MSAppCenterAppSecret() -> String? {
        return featuresCustomizationDict?[FeaturesCusimizationConsts.MSAppCenterAppSecret] as? String
    }
 
}

