//
//  InputPopupView.swift
//  HualWayScan
//
//  Created by NamTrinh on 4/2/25.
//

import SwiftUI

struct InputPopupView: View {
    @FocusState private var isFocus: Bool
    @State private var text = ""
    var message: String
    var onTap: (String) -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Success!")
                .font(.title2)
                .bold()
                .foregroundStyle(.black)
            Text(message)
                .foregroundStyle(.black)
                .padding(.bottom, 8)
            HStack {
                TextField("Enter truck id", text: $text)
                    .focused($isFocus)
                   
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(4)
                    }
                }
            }
            .frame(height: 30)
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
            Button {
                onTap(text)
            } label: {
                Text("Continue")
                    .font(.title3)
                    .foregroundStyle(.white)
            }
            .padding()
            .background(text.isEmpty ? .gray.opacity(0.3) : Color.EF_426_F)
            .cornerRadius(12)
            .disabled(text.isEmpty)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.white)
        .cornerRadius(12)
        .onAppear {
            isFocus = true
        }
    }
}

#Preview {
    InputPopupView(message: "") { _ in
        
    }
}
