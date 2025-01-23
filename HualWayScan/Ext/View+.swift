//
//  View+.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import SwiftUI

extension View {
    func errorAlert(isPresented: Binding<Bool>, errorMessage: String) -> some View {
        self.alert(isPresented: isPresented) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    func showAlert(isPresented: Binding<Bool>, errorMessage: String, primaryTitle: String, secondaryTitle: String, primaryButtonTap: @escaping () -> Void, secondaryButtonTap: @escaping () -> Void) -> some View {
        self.alert(isPresented: isPresented) {
            Alert(
                title: Text(""),
                message: Text(errorMessage),
                primaryButton: .default(Text("Update"), action: primaryButtonTap),
                secondaryButton: .default(Text("Rescan"), action: secondaryButtonTap)
            )
        }
    }
    
    func defaultAlert(isPresented: Binding<Bool>, title: String, message: String, primaryTitle: String, secondaryTile: String, primaryButtonTap: @escaping () -> Void, secondaryButtonTap: @escaping () -> Void) -> some View {
        self.alert(isPresented: isPresented) {
            Alert(
                title: Text(title),
                message: Text(message),
                primaryButton: .default(Text(primaryTitle), action: primaryButtonTap),
                secondaryButton: .default(Text(secondaryTile), action: secondaryButtonTap)
            )
        }
    }
}
