//
//  Feature.swift
//  AppStoreMock
//
//  Created by UAPMobile on 2022/02/04.
//

import Foundation

struct Feature: Decodable {
    let type: String
    let appName: String
    let description: String
    let imageURL: String
}
