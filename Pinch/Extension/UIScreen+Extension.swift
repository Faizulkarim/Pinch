//
//  UIScreen+Extension.swift
//  Pinch
//
//  Created by Md Faizul karim on 13/7/24.
//


import SwiftUI
extension UIScreen {
    
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
