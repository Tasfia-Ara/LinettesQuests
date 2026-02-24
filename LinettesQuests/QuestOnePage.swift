//
//  QuestOnePage.swift
//  LinettesQuests
//
//  Created by Tasfia Ara on 2026-02-21.
//
import SwiftUI

struct QuestOneGameView: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Game state
    @State private var clickNum = 0
    @State private var lives = 3
    @State private var orangeErrors = 0
    @State private var selectedOptions: [Int: String] = [:]
    @State private var buttonColors: [Int: Color] = [:]
    @State private var navigateToExplanation = false
    @State private var gameWon = false
    @State private var gameLost = false
    
    // Mapping dictionaries (10 options)
    let possibleOptionsKeyImageMap: [Int: String] = [
        1: "Islandop1Image",
        2: "Islandop2Image",
        3: "Islandop3Image",
        4: "Islandop4Image",
        5: "Islandop5Image",
        6: "Islandop6Image",
        7: "Islandop7Image",
        8: "Islandop8Image",
        9: "Islandop9Image",
        10: "Islandop10Image"
    ]
    
    let correctKeySet: Set<Int> = [1, 3, 5, 6]
    let correctList: [Int] = [1, 3, 5, 6]
    
    func checkSelection(selectedKey: Int) {
        // Check if completely correct
        if correctKeySet.contains(selectedKey) && correctList[clickNum] == selectedKey {
            // Completely correct - green background
            buttonColors[selectedKey] = Color.green.opacity(0.5)
            selectedOptions[clickNum + 1] = possibleOptionsKeyImageMap[selectedKey]
            clickNum += 1
            
            // Check win condition
            if clickNum == 4 && lives > 0 {
                gameWon = true
            }
        } else if correctKeySet.contains(selectedKey) {
            // Correct key but wrong order - orange background
            buttonColors[selectedKey] = Color.orange.opacity(0.5)
            orangeErrors += 1
            
            // Lose a life if more than 1 orange error
            if orangeErrors > 1 {
                lives -= 1
                
                // Check lose condition
                if lives == 0 {
                    gameLost = true
                }
            }
        } else {
            // Completely wrong - red background and lose a life
            buttonColors[selectedKey] = Color.red.opacity(0.5)
            lives -= 1
            
            // Check lose condition
            if lives == 0 {
                gameLost = true
            }
        }
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                // Background image - consistent scaling
                Image("questonepage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: UIScreen.main.bounds.height)
                
                // Hidden NavigationLink to DFS Explanation
                NavigationLink(destination: DFSExplanationPage(), isActive: $navigateToExplanation) {
                    EmptyView()
                }
                
                // Back button and hearts at top
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
                        .padding(.top, 20)
                        
                        Spacer()
                        
                        // Hearts display at top right
                        HStack(spacing: 5) {
                            ForEach(0..<max(0, lives), id: \.self) { _ in
                                Image("Heart")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
                .frame(minHeight: UIScreen.main.bounds.height)
                
                // Main content area
                if gameWon {
                    // WIN SCREEN
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            ZStack {
                                        Image("quest2TextBox")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 350)
                                        
                                        VStack(spacing: 10) {
                                            Text("You Win!")
                                                .font(.custom("Courier", size: 32))
                                                .foregroundColor(.green)
                                                .bold()
                                            
                                            Text("Linette can navigate now.")
                                                .font(.custom("Courier", size: 16))
                                                .foregroundColor(.black)
                                        }
                                    }
                            
                            // NEXT button
                            Button(action: {
                                navigateToExplanation = true
                            }) {
                                Image("next-button")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 40)
                            }
                        }
                        
                        Spacer()
                    }
                } else if gameLost {
                    // LOSE SCREEN
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 20) {
                            ZStack {
                                Image("quest2TextBox")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 350)
                                
                                VStack(spacing: 10) {
                                    Text("You Lose.")
                                        .font(.custom("Courier", size: 32))
                                        .foregroundColor(.red)
                                        .bold()
                                    
                                    Text("Linette can't navigate now.")
                                        .font(.custom("Courier", size: 16))
                                        .foregroundColor(.black)
                                }
                            }
                            
                            // NEXT button
                            Button(action: {
                                navigateToExplanation = true
                            }) {
                                Image("next-button")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 40)
                            }
                        }
                        
                        Spacer()
                    }
                } else {
                    // GAME SCREEN
                    VStack(spacing: 0) {
                        // Top section - Cards and Matrix
                        HStack(alignment: .top, spacing: 5) {
                            // LEFT SIDE - Cards stacked vertically WITH OVERLAYS
                            VStack(spacing: -35) {
                                // First card (pre-filled, always visible)
                                Image("IslandCorrectOptions-step1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 180)
                                
                                // Card 2 with potential overlay
                                ZStack {
                                    Image("IslandCorrectOptions-step2to4")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 180)
                                    
                                    if let selectedImage = selectedOptions[1] {
                                        Image(selectedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 180)
                                    }
                                }
                                
                                // Card 3 with potential overlay
                                ZStack {
                                    Image("IslandCorrectOptions-step2to4")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 180)
                                    
                                    if let selectedImage = selectedOptions[2] {
                                        Image(selectedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 180)
                                    }
                                }
                                
                                // Card 4 with potential overlay
                                ZStack {
                                    Image("IslandCorrectOptions-step2to4")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 180)
                                    
                                    if let selectedImage = selectedOptions[3] {
                                        Image(selectedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 180)
                                    }
                                }
                                
                                // Card 5 with potential overlay
                                ZStack {
                                    Image("IslandCorrectOptions-step2to4")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 180)
                                    
                                    if let selectedImage = selectedOptions[4] {
                                        Image(selectedImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 180)
                                    }
                                }
                            }
                            .offset(x: 30, y: -30)
                            
                            Spacer()
                            
                            // RIGHT SIDE - Matrix + Linette
                            ZStack(alignment: .topLeading) {
                                // Matrix image
                                Image("matrix")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 190)
                                
                                // Linette at top-LEFT corner of matrix
                                Image("linette")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                                    .offset(x: 11, y: -14)
                            }
                            .offset(y: 10)
                            .padding(.trailing, 10)
                        }
                        .padding(.top, 80)
                        .padding(.leading, 10)
                        
                        // Bottom section - Options panel
                        ZStack(alignment: .top) {
                            // Background
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(red: 1.0, green: 0.9, blue: 0.7).opacity(1.0))
                                .frame(height: 300)
                            
                            VStack(spacing: -80) {
                                // Choose options instruction
                                Image("ChooseOptions")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200)
                                    .padding(.top, -30)
                                
                                // Scrollable list of options (ALL 10)
                                ScrollView {
                                    VStack(spacing: -60) {
                                        ForEach(1...10, id: \.self) { key in
                                            Button(action: {
                                                checkSelection(selectedKey: key)
                                            }) {
                                                ZStack {
                                                    // Button background - changes color
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(buttonColors[key] ?? Color.white.opacity(0.5))
                                                        .frame(width: 280, height: 70)
                                                    
                                                    // Option image
                                                    Image(possibleOptionsKeyImageMap[key] ?? "")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 270)
                                                }
                                            }
                                        }
                                    }
                                    .padding(.top, 10)
                                }
                                .frame(height: 250)
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 10)
                        .offset(y: -30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    QuestOneGameView()
}
