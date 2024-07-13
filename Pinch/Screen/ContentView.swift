//
//  ContentView.swift
//  Pinch
//
//  Created by Md Faizul karim on 12/7/24.
//

import SwiftUI

struct ContentView: View {
    //MARK: PROPERTY
    @State private var pageIndex = 0
    @State private var isAnimating = false
    @State private var imageOffset = CGSize.zero
    @State private var imageScale = 1.0

    let pages = pagesData
    private var maxScale: CGFloat = 5
    private var minScale: CGFloat = 1
    
    //MARK: Function
    func resetImageState() {
        withAnimation(.spring) {
            imageScale = minScale
            imageOffset = .zero
        }

    }
    var body: some View {
        //MARK: NAVIGATION STACK
        NavigationStack {
            
            // MARK: ZSTACK
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
                //MARK: TAP GESTURE
                    .onTapGesture(count: 2, perform: {
                        if imageScale == minScale {
                            withAnimation(.spring) {
                                imageScale = maxScale
                            }
                        }else{
                            resetImageState()
                        }
                    })
                //MARK: DRAG GESTURE
                    .gesture(
                        DragGesture()
                            .onChanged({ gester in
                                withAnimation(.linear(duration: 1)) {
                                    imageOffset = gester.translation
                                }
                            })
                            .onEnded({ _ in
                                if imageScale == minScale {
                                    resetImageState()
                                }
                            })
                    
                    )

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
