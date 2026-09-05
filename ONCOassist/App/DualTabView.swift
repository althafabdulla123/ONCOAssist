//
//  DualTabView.swift
//  ONCOassist
//
//  Created by Althaf Bin Abdulla on 05/09/26.
//

import SwiftUI

struct DualTabView: View {
    var body: some View {
        TabView {
            MASCCView()
                .tabItem {
                    Label("MASCC", systemImage: "stethoscope")
                }
        }
    }
}


