//
//  String+extension.swift
//  LingvoCam
//
//  Created by Mike Shevelinsky on 22.09.2020.
//  Copyright © 2020 Mike Shevelinsky. All rights reserved.
//

import Foundation


extension String {
    func firstWord() -> String? {
        return self.components(separatedBy: ",").first
    }
}
