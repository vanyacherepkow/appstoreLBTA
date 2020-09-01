//
//  AppGroup.swift
//  AppStoreLBTA
//
//  Created by Иван on 21.04.2020.
//  Copyright © 2020 vanyacherepkow. All rights reserved.
//

import Foundation

struct AppGroup: Decodable {
    let feed: Feed
    
}

struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}

struct FeedResult: Decodable {
    let id, name, artistName, artworkUrl100: String
}
