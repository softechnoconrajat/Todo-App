//
//  List.swift
//  Todo App
//
//  Created by Rajat Kumar on 23/11/18.
//  Copyright © 2018 Rajat Kumar. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable {
    
    var title :String = ""
    var done : Bool = false
    
}
