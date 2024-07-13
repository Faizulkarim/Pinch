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
    @State private var isDrawerOpen  = false

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
                // MARK: - 2. MAGNIFY  GESTURE
                    .gesture(
                        MagnifyGesture()
                         
                            .onChanged { gesture in
                                
                                withAnimation(.linear(duration: 1)) {
                                    
                                    if imageScale >= 1 && imageScale <= 5 {
                                        imageScale = gesture.magnification
                                        
                                    } else if imageScale > 5 {
                                        imageScale = maxScale
                                    }
                                }
                            }
                        
                            .onEnded { _ in
                                withAnimation(.linear(duration: 1)) {
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                        
                                    } else if imageScale > 5 {
                                        imageScale = maxScale
                                    }
                                }
                            }
                    )

            }
            .navigationTitle("Pinch & zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1.0)) {
                    isAnimating = true
                }
            })
            // MARK: - INFO PANEL
            .overlay(alignment: .top) {
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
            }
            // MARK: - CONTROLS
            .overlay(alignment: .bottom) {
                Group {
                    HStack {
                        // SCALE DOWN
                        Button(action: {
                            
                            withAnimation(.spring) {
                                
                                if imageScale > minScale {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        resetImageState()
                                    }
                                }
                            }
                            
                        }) {
                            ControlImageView(systemImage: "minus.magnifyingglass")
                        }
                        
                        // RESET
                        Button(action: {
                            
                            withAnimation(.spring) {
                                
                                if imageScale > minScale {
                                    resetImageState()
                                    
                                } else {
                                    imageScale = maxScale
                                }
                            }
                        }) {
                            ControlImageView(systemImage: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                        
                        // SCALE UP
                        Button(action: {
                            withAnimation(.spring) {
                                if imageScale < maxScale {
                                    imageScale += 1
                                    
                                    if imageScale > maxScale {
                                        imageScale = maxScale
                                    }
                                }
                            }
                            
                        }) {
                            ControlImageView(systemImage: "plus.magnifyingglass")
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 12, bottomLeading: 12, bottomTrailing: 12, topTrailing: 12)))
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom, 30)
            }
            
            
            // MARK: - DRAWER
            .overlay(alignment: .topTrailing) {
                    HStack(spacing: 12) {
                    // MARK: - DRAWER HANDLE
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture {
                            
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        }
                    
                    // MARK: - THUMBNAILS
                    
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 8, bottomLeading: 8, bottomTrailing: 8, topTrailing: 8)))
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id - 1
                            }
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 8)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 12, bottomLeading: 12, bottomTrailing: 12, topTrailing: 12 )))
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, (UIScreen.current?.bounds.height)! / 12)
                .offset(x: isDrawerOpen ? 20 : 215)
            }
        }
    }
}

#Preview {
    ContentView()
}
