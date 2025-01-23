//
//  ContentView.swift
//  HualWayScan
//
//  Created by NamTrinh on 20/1/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()
    
    @State private var isShowHome = false
    @State private var barCode = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                CodeScannerView(codeTypes: [.qr], showViewfinder: true, simulatedData: "Paul Hudson") { response in
                    switch response {
                    case .success(let result):
                        print("Found code: \(result.string)")
                        self.barCode = result.string
                        viewModel.postAppliance(code: result.string)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                VStack {
                    Spacer()
                    Button {
                        toggleFlash()
                    } label: {
                        Image(.icOnFlash)
                    }
                }
                .padding(.bottom, 42)
            }
            .navigationDestination(isPresented: $viewModel.isShowUpdateView) {
                HomeView(isShow: $viewModel.isShowUpdateView, barCode: barCode)
            }
            .navigationDestination(isPresented: $viewModel.isShowInfoView) {
                InfoView(isShow: $viewModel.isShowInfoView)
            }
        }
        .alert("Added!", isPresented: $viewModel.isSuccess) {
            Button("OK", action: {
                viewModel.isSuccess.toggle()
                NotificationCenter.default.post(name: NSNotification.rescan, object: nil, userInfo: nil)
            })
        } message: {
           
        }
        .errorAlert(isPresented: $viewModel.isError, errorMessage: viewModel.errorStr ?? "", primaryButtonTap: {
            viewModel.getAppliance(code: barCode)
        }, secondaryButtonTap: {
            NotificationCenter.default.post(name: NSNotification.rescan, object: nil, userInfo: nil)
        })
        .ignoresSafeArea(.all)
    }
}

extension ContentView {
    func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }

            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
}

#Preview {
    ContentView()
}
