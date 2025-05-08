//
//  String+Localized.swift
//  AsynchronousDragonBall
//
//  Created by Ire  Av on 8/5/25.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    func localized(arguments: CVarArg...) -> String {
        String(format: self.localized, arguments)
    }
}
