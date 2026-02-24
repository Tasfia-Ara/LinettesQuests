//
//  QuestTwoInstructionsView.swift
//  LinettesQuests
//
//  Created by Tasfia Ara on 2026-02-21.
//

import SwiftUI

struct QuestTwoInstructionsView: View {
    @State private var navigateToQuest2Game = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            ZStack {
                // Background image - fits screen
                Image("quest2-background")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: UIScreen.main.bounds.height)
                
                // Back button at top left
                VStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 4) {
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
                
                // NEXT button at bottom right
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        // Hidden NavigationLink to Quest 2 Game Page
                        NavigationLink(destination: QuestTwoPage(), isActive: $navigateToQuest2Game) {
                            EmptyView()
                        }
                        
                        // NEXT button
                        Button(action: {
                            navigateToQuest2Game = true
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
    QuestTwoInstructionsView()
}
