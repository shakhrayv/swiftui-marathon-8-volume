//
//  ContentView.swift
//  swiftui-marathon-8-volume
//
//  Created by Vladislav Shakhray on 20/10/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var volume: CGFloat = 0.5
    @State private var offset: CGSize = .zero

    let defaultHeight: CGFloat = 158
    let defaultWidth: CGFloat = 72
    
    func dampen(_ value: CGFloat, dampeningFactor: CGFloat = 10.0) -> CGFloat {
        if value < 0.0 { return value / dampeningFactor }
        else if value > 1.0 { return CGFloat(1.0) + (value - 1) / dampeningFactor }
        return value
    }
    
    var currentVolume: CGFloat {
        return dampen(volume - offset.height / defaultHeight)
    }
    
    var safeCurrentVolume: CGFloat {
        return min(1.0, max(0.0, currentVolume))
    }
    
    var xScale: CGFloat {
        if currentVolume > 1.0  {
            return 1 / CGFloat(sqrt(Double(currentVolume)))
        } else if currentVolume < 0.0 {
            return 1 / CGFloat(sqrt(Double(1 - currentVolume)))
        } else {
            return 1.0
        }
    }
    
    var yScale: CGFloat {
        return 1 / xScale
    }
    
    var yOffset: CGFloat {
        if currentVolume > 1.0 {
            return -defaultHeight * (yScale - 1.0)
        } else if currentVolume < 0.0 {
            return defaultHeight * (yScale - 1.0)
        } else {
            return 0.0
        }
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("background")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
                    .ignoresSafeArea()
                    .blur(radius: 10.0)
                VStack {
                    Color.black.background(.ultraThinMaterial)
                        .opacity(0.5)
                        .frame(width: defaultWidth * xScale, height: defaultHeight * yScale)
                        .overlay(alignment: .bottom) {
                            Color.white.background(.thickMaterial)
                                        .opacity(0.7)
                                        .frame(width: defaultWidth * xScale, height: defaultHeight * yScale * safeCurrentVolume)
                
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 22)
                        )
                        .scaleEffect(x: xScale, y: yScale)
                        .offset(y: yOffset)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                    
                                }
                                .onEnded { value in
                                    withAnimation {
                                        volume = safeCurrentVolume
                                        offset = .zero
                                    }
                                }
                        )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
