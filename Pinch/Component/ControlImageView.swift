//
//  ControlImageView.swift
//  Pinch
//
//  Created by Md Faizul karim on 13/7/24.
//

import SwiftUI


struct ControlImageView: View {
    
    var systemImage: String
    
    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 36))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ControlImageView(systemImage: "minus.magnifyingglass")
        .padding()
}
