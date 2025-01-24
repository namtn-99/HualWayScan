//
//  SuccessPopupView.swift
//  HualWayScan
//
//  Created by NamTrinh on 23/1/25.
//

import SwiftUI

struct SuccessPopupView: View {
    var message: String
    var onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark.circle")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundStyle(.green)
                .padding(.bottom, 4)
            Text("Success!")
                .font(.title2)
                .bold()
                .foregroundStyle(.black)
            Text(message)
                .foregroundStyle(.black)
                .padding(.bottom, 8)
            Button {
                onTap()
            } label: {
                Text("Awesome!")
                    .font(.title3)
                    .foregroundStyle(.white)
            }
            .padding()
            .background(Color.EF_426_F)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .cornerRadius(12)
    }
}

#Preview {
    SuccessPopupView() {
        
    }
}
