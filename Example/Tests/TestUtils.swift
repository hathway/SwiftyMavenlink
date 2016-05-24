//
//  TestUtils.swift
//  SwiftyMavenlink
//
//  Created by Mike Maxwell on 5/24/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation

func getQueryStringParameter(url: String, param: String) -> String? {

    guard let url = NSURLComponents(string: url) else { return nil }
    guard let queryItems = url.queryItems else { return nil }

    return queryItems.filter({ (item) in item.name == param }).first?.value

}