//
//  InfoView.swift
//  HualWayScan
//
//  Created by NamTrinh on 22/1/25.
//

import SwiftUI

struct InfoView: View {
    @Binding var isShow: Bool
    
    var model: ApplianceModel?
    
    var body: some View {
        VStack {
            headerView
            
            Spacer()
            Text("Info view")
        }
        .navigationBarHidden(true)
    }
}

extension InfoView {
    private var headerView: some View {
        HStack {
            Button {
                isShow.toggle()
            } label: {
                Text("< Back")
            }
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var categoryView: some View {
        HStack {
            
        }
    }
}

#Preview {
    InfoView(isShow: .constant(true))
}
