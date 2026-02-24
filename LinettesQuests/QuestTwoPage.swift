//
//  QuestTwoPage.swift
//  LinettesQuests
//
//  Created by Tasfia Ara on 2026-02-21.
//
import SwiftUI

struct QuestTwoPage: View {
    @Environment(\.presentationMode) var presentationMode
    
    // Game state
    @State private var lives = 3
    @State private var currentBracketIndex = 0
    @State private var stackItems: [String] = []
    @State private var validContainerCount = 0
    @State private var errorMessage = ""
    @State private var showErrorMessage = false
    @State private var highlightColor = Color.blue
    @State private var isShaking = false
    @State private var isHopping = false
    @State private var gameWon = false
    @State private var gameLost = false
    @State private var navigateToExplanation = false
    
    // Bracket mappings
    let brackets: [String: String] = [
        "bracket1open": "quest2openbracket1",
        "bracket1close": "quest2closebracket1",
        "bracket2open": "quest2openbracket2",
        "bracket2close": "quest2closebracket2",
        "bracket3open": "quest2openbracket3",
        "bracket3close": "quest2closebracket3"
    ]
    
    // Level sequence (5 valid pairs, invalid ending)
    let shownSequenceL1: [String] = [
        "bracket1open",   // (
        "bracket1close",  // )
        "bracket2open",   // [
        "bracket3open",   // {
        "bracket1open",   // (
        "bracket1close",  // )
        "bracket3close",  // }
        "bracket3open",   // {
        "bracket1open",   // (
        "bracket2open",   // [
        "bracket1open",   // (
        "bracket1close",  // )
        "bracket2close"   // ]
    ]
    
    func checkWinCondition() {
        // Check if all brackets processed and still have lives
        if currentBracketIndex >= shownSequenceL1.count && lives > 0 {
            gameWon = true
        }
    }
    
    func checkLoseCondition() {
        // Check if lives hit 0
        if lives <= 0 {
            gameLost = true
        }
    }
    
    func handlePush() {
        let currentBracket = shownSequenceL1[currentBracketIndex]
        
        // Check if it's an open bracket
        if currentBracket.contains("open") {
            // Correct! Add to stack
            stackItems.append(currentBracket)
            currentBracketIndex += 1
            checkWinCondition()
        } else {
            // Wrong! It's a close bracket
            lives -= 1
            checkLoseCondition()
            
            if !gameLost {
                errorMessage = "Invalid Push - Pop instead!"
                showErrorMessage = true
                highlightColor = Color.red
                
                // Trigger animations
                withAnimation(.default.speed(3)) {
                    isHopping = true
                }
                
                // Reset after 0.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    highlightColor = Color.blue
                    isShaking = false
                    isHopping = false
                    showErrorMessage = false
                }
            }
        }
    }
    
    func handlePop() {
        let currentBracket = shownSequenceL1[currentBracketIndex]
        
        // Check if it's a close bracket
        if currentBracket.contains("close") {
            // Extract bracket type (1, 2, or 3)
            let currentType = currentBracket.replacingOccurrences(of: "bracket", with: "").replacingOccurrences(of: "close", with: "").replacingOccurrences(of: "open", with: "")
            
            // Check if stack is not empty
            guard !stackItems.isEmpty else {
                // Stack empty but trying to pop
                lives -= 1
                checkLoseCondition()
                
                if !gameLost {
                    errorMessage = "Stack is empty!"
                    showErrorMessage = true
                    highlightColor = Color.red
                    
                    withAnimation(.default.speed(3)) {
                        isHopping = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        highlightColor = Color.blue
                        isHopping = false
                        showErrorMessage = false
                    }
                }
                return
            }
            
            // Get top of stack
            let topOfStack = stackItems.last!
            let topType = topOfStack.replacingOccurrences(of: "bracket", with: "").replacingOccurrences(of: "open", with: "").replacingOccurrences(of: "close", with: "")
            
            // Check if types match
            if currentType == topType {
                // MATCH! Valid pair found
                stackItems.removeLast()
                validContainerCount += 1
                currentBracketIndex += 1
                checkWinCondition()
            } else {
                // TODO: CASE 2 - Mismatch (for future extension with multiple sequences)
                // Currently skipped as shownSequenceL1 never has mismatches
                // Future implementation: Show error, potentially end game immediately
                // as this indicates an invalid sequence per standard algorithm
            }
        } else {
            // Wrong! It's an open bracket
            lives -= 1
            checkLoseCondition()
            
            if !gameLost {
                errorMessage = "Invalid Pop - Push instead!"
                showErrorMessage = true
                highlightColor = Color.red
                
                // Trigger animations
                withAnimation(.default.speed(3)) {
                    isHopping = true
                }
                
                // Reset after 0.5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    highlightColor = Color.blue
                    isHopping = false
                    showErrorMessage = false
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            ZStack {
                // Background image - consistent scaling
                Image("questtwopage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(minHeight: UIScreen.main.bounds.height)
                
                // Hidden NavigationLink to Stack Explanation
                NavigationLink(destination: QuestTwoExplanationPage(), isActive: $navigateToExplanation) {
                    EmptyView()
                }
                
                // Error message overlay (center of screen)
                if showErrorMessage && !gameWon && !gameLost {
                    VStack {
                        Spacer()
                        Text(errorMessage)
                            .font(.custom("Courier", size: 18))
                            .foregroundColor(.red)
                            .bold()
                            .padding(15)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        Spacer()
                    }
                    .zIndex(10)
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
                
                // Main game content
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
                                    
                                    Text("Linette has \(validContainerCount) valid containers")
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
                                    
                                    Text("There would be 5 valid containers")
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
                    VStack(spacing: 30) {
                        // Text box with overlaid text AND brackets
                        ZStack {
                            Image("quest2text")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 330)
                        
                            Image("quest2TextBox")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 350)
                                .offset(y: 100)
                            
                            // Brackets displayed horizontally in the text box
                            HStack(spacing: -30) {
                                ForEach(0..<shownSequenceL1.count, id: \.self) { index in
                                    // Only show brackets that haven't been processed yet
                                    if index >= currentBracketIndex {
                                        ZStack {
                                            // Highlight background for current bracket
                                            if index == currentBracketIndex {
                                                RoundedRectangle(cornerRadius: 5)
                                                    .fill(highlightColor.opacity(0.3))
                                                    .frame(width: 25, height: 50)
                                                    .offset(y: 20)
                                                    .offset(x: isShaking ? -5 : 0)
                                            }
                                            
                                            // Bracket image
                                            Image(brackets[shownSequenceL1[index]] ?? "")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 55, height: 60)
                                                .offset(y: 20)
                                            
                                            // Linette on top of current bracket
                                            if index == currentBracketIndex {
                                                Image("linette")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 60, height: 60)
                                                    .offset(y: isHopping ? -40 : -25)
                                            }
                                        }
                                    }
                                }
                            }
                            .offset(y: 100)
                        }
                        
                        // Stack display with valid pairs tracker
                        HStack(spacing: 10) {
                            ZStack(alignment: .bottom) {
                                Image("quest2stack")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 160)
                                    .fixedSize()
                                
                                // Stack items displayed vertically (REVERSED - top is newest)
                                VStack(spacing: 2) {
                                    ForEach(Array(stackItems.reversed().enumerated()), id: \.offset) { index, item in
                                        Image(brackets[item] ?? "")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 40, height: 40)
                                    }
                                }
                                .offset(y: -10)
                            }
                            
                            // Valid pairs tracker
                            Text("Valid: \(validContainerCount)")
                                .font(.custom("Courier", size: 16))
                                .foregroundColor(.black)
                                .bold()
                                .offset(x: 10, y: -50)
                        }
                        .offset(y: 60)
                        
                        Spacer()
                        
                        // Push and Pop buttons at bottom
                        HStack(spacing: 20) {
                            Button(action: {
                                handlePush()
                            }) {
                                Image("Push")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 60)
                            }
                            
                            Button(action: {
                                handlePop()
                            }) {
                                Image("Pop")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 150, height: 60)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// Placeholder for Quest Two Explanation Page
struct QuestTwoExplanationPage: View {
    var body: some View {
        Text("Stack Explanation Coming Soon!")
            .font(.largeTitle)
            .navigationBarHidden(true)
    }
}
#Preview {
    QuestTwoPage()
}
