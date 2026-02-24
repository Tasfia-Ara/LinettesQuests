//
//  DFSExplanationPage.swift
//  LinettesQuests
//
//  Created by Tasfia Ara on 2026-02-21.
//

import SwiftUI

struct DFSExplanationPage: View {
    @State private var navigateToQuest2 = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            ZStack {
                // Background image - fits screen
                Image("DFSBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: UIScreen.main.bounds.height)
                
                // Back button at top left
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 0) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.3))
                            .cornerRadius(8)
                        }
                        .padding(.leading, 20)
                        .padding(.top, 50)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height)
                
                // Scrollable content area (aligned with white box)
                VStack {
                    // Scrollable explanation images
                    ScrollView {
                        VStack(spacing: -30) {
                            Image("dfsexplanationt1")
                                .resizable()
                                .scaledToFit()
                            
                            Image("dfsexplanationt2")
                                .resizable()
                                .scaledToFit()
                            
                            Image("dfsexplanationim1")
                                .resizable()
                                .scaledToFit()
                            
                            Image("dfsexplanationt3")
                                .resizable()
                                .scaledToFit()
                            
                            Image("dfsexplanationim2")
                                .resizable()
                                .scaledToFit()
                            
                            Image("dfsexplanationt4")
                                .resizable()
                                .scaledToFit()
                            
                            Image("dfsexplanationim3")
                                .resizable()
                                .scaledToFit()
                            
                            Image("dfsexplanationt5")
                                .resizable()
                                .scaledToFit()
                            
                            Image("dfsexplanationim4")
                                .resizable()
                                .scaledToFit()
                            
                            Image("dfsexplanationt6")
                                .resizable()
                                .scaledToFit()
                        }
                        .padding(.horizontal, 2) // Padding to fit within white box
//                        .padding(.vertical, 20)
                    }
                    .frame(width: 350, height: 500)
//                    .padding(.top, 130) // Start where white box begins
                }
                .offset(y: -20)
                .frame(minHeight: UIScreen.main.bounds.height)
                
                // NEXT button at bottom right
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        // Hidden NavigationLink to Quest 2 Instructions
                        NavigationLink(destination: QuestTwoInstructionsView(), isActive: $navigateToQuest2) {
                            EmptyView()
                        }
                        
                        // NEXT button
                        Button(action: {
                            navigateToQuest2 = true
                        }) {
                            Image("next-button")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 40)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 110)
                    }
                }
                .frame(minHeight: UIScreen.main.bounds.height)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    DFSExplanationPage()
}
