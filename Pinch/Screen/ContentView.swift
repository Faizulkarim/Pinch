//
//  ContentView.swift
//  Pinch
//
//  Created by Md Faizul karim on 12/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var pageIndex = 0
    @State private var isAnimating = false
    @State private var imageOffset = CGSize.zero
    @State private var imageScale = 1.0

    let pages = pagesData
    private var maxScale: CGFloat = 5
    private var minScale: CGFloat = 1
    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                Image(pages[pageIndex].imageName)
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 10, bottomLeading: 10, bottomTrailing: 10, topTrailing: 10)))
                    .padding()
                    .shadow(color: .black.opacity(0.4), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .scaleEffect(imageScale)
                    .onTapGesture(count: 2, perform: {
                        if imageScale == minScale {
                            withAnimation(.spring) {
                                imageScale = maxScale
                            }
                        }else{
                            withAnimation(.spring) {
                                imageScale = minScale
                                imageOffset = .zero
                            }
                        }
                    })

            }
            .navigationTitle("Pinch & zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1.0)) {
                    isAnimating = true
                }
            })
        }
    }
}

#Preview {
    ContentView()
}
