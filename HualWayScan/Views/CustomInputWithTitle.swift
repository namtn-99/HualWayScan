//
//  CustomInputWithTitle.swift
//  HualWayScan
//
//  Created by NamTrinh on 26/1/25.
//

import SwiftUI

struct CustomInputWithTitle: View {
    @Binding var text: String
    var title: String
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack {
                TextField("Enter \(title.lowercased())", text: $text)
                    .keyboardType(keyboardType)
                   
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
        }
    }
}
