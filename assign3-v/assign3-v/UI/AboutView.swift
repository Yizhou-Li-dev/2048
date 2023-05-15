//
//  AboutView.swift
//  assign3
//
//  Created by Yizhou Li on 10/9/21.
//

import SwiftUI

struct AboutView: View {
    @State var isTrigger = false
    
    var body: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 4)) {
                self.isTrigger.toggle()
            }
        }) {
            Image(systemName: "chevron.right.circle")
                .imageScale(.large)
                .rotationEffect(.degrees(isTrigger ? 90 : 0))
                .scaleEffect(isTrigger ? 5 : 1)
                .padding()
        }
    }
}
