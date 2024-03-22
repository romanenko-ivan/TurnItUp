//
//  ContentView.swift
//  TurnItUp
//
//  Created by Романенко Иван on 21.03.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var progress = CGFloat.zero
    @State private var dragOffset = CGFloat.zero
    @State private var lastDragOffset = CGFloat.zero
    
    var body: some View {
        Group {
            GeometryReader {
                let size = $0.size
                let orientationSize = size.height
                let progressValue = max(progress, .zero) * orientationSize
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                    
                    Rectangle()
                        .fill(Color.white)
                        .frame(height: progressValue)
                }
                .clipShape(.rect(cornerRadius: 15))
                .optionalSize(
                    size: size,
                    progress: progress,
                    orientationSize: orientationSize
                )
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged {
                            let translation = $0.translation
                            let movement = -translation.height + lastDragOffset
                            
                            dragOffset = movement
                            calculateProgress(with: orientationSize)
                        }
                        .onEnded { value in
                            withAnimation(.smooth) {
                                dragOffset = dragOffset > orientationSize ? orientationSize : (dragOffset < 0 ? 0 : dragOffset)
                                calculateProgress(with: orientationSize)
                            }
                            
                            lastDragOffset = dragOffset
                        }
                )
                .frame(
                    maxWidth: size.width,
                    maxHeight: size.height,
                    alignment: progress < 0 ? .top : .bottom
                )
            }
            .frame(width: 80, height: 180)
            .frame(maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .background(backgroundView)
    }
    
    private var backgroundView: some View {
        Image("bg")
            .resizable()
            .ignoresSafeArea()
            .blur(radius: 20, opaque: true)
    }
    
    private func calculateProgress(with orientationSize: CGFloat) {
        let topOffset = orientationSize + (dragOffset - orientationSize) * 0.1
        let bottomOffset = dragOffset < 0 ? (dragOffset * 0.1) : dragOffset
        let tempProgress = (dragOffset > orientationSize ? topOffset : bottomOffset) / orientationSize
        progress = tempProgress > 1.1 ? 1.1 : tempProgress
    }
}

extension View {
    @ViewBuilder
    func optionalSize(
        size: CGSize,
        progress: CGFloat,
        orientationSize: CGFloat
    ) -> some View {
        self
            .frame(height: progress < 0 ? size.height + (-progress * size.height) : nil)
    }
}

#Preview {
    ContentView()
}
