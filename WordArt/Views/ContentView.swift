//
//  ContentView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//  https://www.colourlovers.com/palette/3636765/seapunk_vaporwave

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var outputModel: FancyTextModel
    let userSettings = UserSettings()
    @State private var showSheet: sheetEnum?
    
    @State private var currentFancyText = "fancy"
    @State private var bottomText = ""
    
    @FocusState private var inputIsFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        
        let gradient = [Color("AccentColor"), Color("GradientEnd")]
        
        VStack (spacing: 10) {
            
            if outputModel.isExpanded {
                
                if outputModel.isFullApp {
                    TitleView()
                }
                
                // MARK: INPUT AREA
                HStack {
                    TextField("Type anything to begin", text: $outputModel.userInput, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(colorScheme == .dark ? Color("AccentColor") : .black)
                        .font(.title3)
                        .focused($inputIsFocused)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    inputIsFocused = false
                                } // Button
                            } // ToolbarItemGroup
                        } // toolbar
                    
                    // Clear Button
                    if (outputModel.userInput != String()) {
                        Button {
                            withAnimation {
                                outputModel.userInput = String()
                                outputModel.clearAllOptions()
                            }
                        } label: {
                            Image(systemName: "x.square.fill")
                                .imageScale(.large)
                                .foregroundColor(Color("AccentColor"))
                        } // Button
                        .keyboardShortcut(.cancelAction)
                    } // if
                } // HStack
                .padding(.bottom)
                
                // MARK: OUTPUT AREA
                OutputView(bottomText: $bottomText)
                    .environmentObject(outputModel)
                    .onAppear {
                        inputIsFocused = true
                    }
                
                Spacer()
                
                // MARK: Notification and Help Button
                HStack {
                    if outputModel.userInput != String() {
                        ZStack {
                            OutputButton(label: bottomText)
                                .font(.caption)
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(
                                    Color("BorderColor"),
                                    lineWidth: 2)
                        } // ZStack
                    }
                    Spacer()
                    Button {
                        showSheet = .helpSheet
                    } label: {
                        Image(systemName: "questionmark.circle.fill")
                            .imageScale(.large)
                            .padding(.trailing)
                    } // Button
                } // HStack
                .frame(maxHeight: 42)
                .foregroundStyle(LinearGradient(
                    colors: gradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing))
            } else {
                CompactView()
                    .environmentObject(outputModel)
            }
            
        } // VStack
        .tint(Color("AccentColor"))
        .padding()
        .background(Color("BackgroundColor"), ignoresSafeAreaEdges: .all)
        .onChange(of: outputModel.userInput) { _ in
            outputModel.createSpecialText(outputModel.userInput)
            if outputModel.userInput != String() {
                bottomText = "Tap an icon to copy it to your clipboard."
            } else {
                bottomText = String()
            } // if-else
        } // onChange
        .onAppear {
            outputModel.userInput = String()
            checkForUpdate()
        } // onAppear
        .sheet(item: $showSheet) { item in
            switch item {
            case .helpSheet:
                HelpView()
            case .whatsNewSheet:
                if outputModel.isFullApp {
                    WhatsNewView()
                } // if
            } // switch
        } // sheet
        .onChange(of: outputModel.activeCombiningMarks) { _ in
            inputIsFocused = false
        }
        .onChange(of: outputModel.finalOutput) { _ in
            inputIsFocused = false
        }
        .onChange(of: outputModel.activeFontStyle) { _ in
            inputIsFocused = false
        }
        
    } // View
    
    // Get current version of the app bundle
    func getCurrentAppVersion() -> String {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        let version = (appVersion as! String)
        return version
    }
    
    // Check if app if app has been started after update
    func checkForUpdate() {
        let version = getCurrentAppVersion()
        let savedVersion = UserDefaults.standard.string(forKey: "savedVersion")
        if savedVersion != version  && self.userSettings.notFirstLaunch {
            // Toogle to show WhatsNew Screen as Modal
            inputIsFocused = false
            showSheet = .whatsNewSheet
        } else {
            inputIsFocused = true
        }
        
        UserDefaults.standard.set(version, forKey: "savedVersion")
        self.userSettings.notFirstLaunch = true
    }
    
    enum sheetEnum: Identifiable {
        case helpSheet, whatsNewSheet
        var id: Int {
            hashValue
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(outputModel: FancyTextModel(true))
    }
}
