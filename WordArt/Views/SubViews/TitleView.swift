//
//  TitleView.swift
//  WordArt
//
//  Created by Joseph Adam Iannazzone on 3/7/23.
//

import SwiftUI

struct TitleView: View {
    
    let gradient = [Color("AccentColor"), Color("GradientEnd")]
    
    var body: some View {
        Text("π΅π°π½π²πΈπ΅ππ» π΅πΎπ½ππ")
            .font(.system(size: 42))
            .bold()
            .foregroundStyle(LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing))
            .multilineTextAlignment(.center)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
