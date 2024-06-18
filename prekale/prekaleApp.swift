//
//  prekaleApp.swift
//  prekale
//
//  Created by Kevin Wang on 2024-06-15.
//

import SwiftUI

struct MacOSProgressIndicator: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false

    var body: some View {
        GeometryReader { geometry in
            let lineWidth: CGFloat = 40
            let size = min(geometry.size.width, geometry.size.height)
            let frameSize = size - lineWidth

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: lineWidth)

                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.accentColor)
                    .rotationEffect(Angle(degrees: isAnimating ? 1080 : 0))
                    .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: true), value: isAnimating)
            }
            .frame(width: frameSize, height: frameSize)
            .onAppear {
                isAnimating = true
            }
        }
        .padding(20)  // Adjust padding as needed
    }
}

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
//            ProgressView()
//                .progressViewStyle(CircularProgressViewStyle())
//                .scaleEffect(2)
            MacOSProgressIndicator().scaleEffect(0.2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(colorScheme == .dark ? Color.black.opacity(0.1) : Color.teal.opacity(0.05))
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}

@main
struct prekaleApp: App {
    @State private var showSplashScreen = true
        
        var body: some Scene {
            WindowGroup {
                if showSplashScreen {
                    SplashScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showSplashScreen = false
                                }
                            }
                        }
                } else {
                    ContentView() // Your main content view
                }
            }
        }
}

#Preview {
    SplashScreenView()
}
