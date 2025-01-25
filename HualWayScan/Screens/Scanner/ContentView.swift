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
    @State private var isShowContinueUpdate = !AppSettings.barcode.isEmpty
    
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
                
                if viewModel.isSuccess {
                    GeometryReader { _ in
                        SuccessPopupView(message: "Added!", onTap: {
                            viewModel.isSuccess.toggle()
                            NotificationCenter.default.post(name: NSNotification.rescan, object: nil, userInfo: nil)
                        })
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(.horizontal, 16)
                    }
                    .background(
                        Color.black.opacity(0.65)
                            .edgesIgnoringSafeArea(.all)
                            
                    )
                }
            }
            .navigationDestination(isPresented: $viewModel.isShowUpdateView) {
                HomeView(isShow: $viewModel.isShowUpdateView, model: $viewModel.applianceModel, barCode: barCode)
            }
            .navigationDestination(isPresented: $viewModel.isShowInfoView) {
                InfoView(isShow: $viewModel.isShowInfoView, model: $viewModel.applianceModel)
            }
        }
//        .showAlert(isPresented: $isShowContinueUpdate, errorMessage: "Do you want to continue updating?", primaryTitle: "Continue", secondaryTitle: "Cancel", primaryButtonTap: {
//            barCode = AppSettings.barcode
//            isShowHome.toggle()
//        }, secondaryButtonTap: {
//            AppSettings.barcode = ""
//        })
        .onChange(of: viewModel.isError) { newValue in
            if newValue {
                viewModel.isError = false
                viewModel.getAppliance(code: barCode)
            }
        }
//        .showAlert(isPresented: $viewModel.isError, errorMessage: viewModel.errorStr ?? "", primaryTitle: "Update", secondaryTitle: "Cancel", primaryButtonTap: {
//            viewModel.getAppliance(code: barCode)
//        }, secondaryButtonTap: {
//            NotificationCenter.default.post(name: NSNotification.rescan, object: nil, userInfo: nil)
//        })
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
