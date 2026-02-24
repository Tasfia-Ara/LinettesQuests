//
//  LandingView.swift
//  LinettesQuests
//
//  Created by Tasfia Ara on 2026-02-20.
//
import SwiftUI

struct LandingView: View {
    @State private var navigateToStory = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    // Background image - fits screen
                    Image("landing-background")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(minHeight: UIScreen.main.bounds.height)
                    
                    VStack {
                        Spacer()
                            .frame(height: 290)
                        
                        // Hidden NavigationLink
                        NavigationLink(destination: StoryView(), isActive: $navigateToStory) {
                            EmptyView()
                        }
                        
                        // START button - centered
                        Button(action: {
                            navigateToStory = true
                        }) {
                            Image("start-button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 107, height: 50)
                        }
                        .offset(x:5)
                        
                        Spacer()
                    }
                    .frame(minHeight: UIScreen.main.bounds.height)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LandingView()
}
