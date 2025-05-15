//
//  ContentView.swift
//  CatsDogsImageClassififcation
//
//  Created by EKbana on 15/05/2025.
//

import SwiftUI
import PhotosUI
import CoreML

struct ContentView: View {
    
    @State private var selectedPhotoItem:PhotosPickerItem? = nil
    @State private var uiImage:UIImage? = UIImage(named: "placeholder")
    @State private var predictions: [String:Double] = [:]
    @State private var isCameraPresented = false
    
    let model = try! CatDogImageClassificationModel(configuration: MLModelConfiguration())
    var sortPredictions:[Dictionary<String, Double>.Element] {
        predictions.sorted { lhs, rhs in
            lhs.value > rhs.value
        }
    }
    var body: some View {
        NavigationStack {
            VStack(spacing:20) {
                Spacer()
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200,height: 200)
                }
                HStack {

                    PhotosPicker(selection: $selectedPhotoItem) {
                        Text("Select Image")
                    }.buttonStyle(.bordered)
                        .tint(.red)
                    
                    Button {
                        isCameraPresented = true
                    } label: {
                        Text("Camera")
                    }.tint(.green)
                        .buttonStyle(.bordered)
                }
                
                Button {
                    if let resizedImage = self.uiImage?.resizeTo(to: CGSize(width: 299, height: 299)),  let buffer = resizedImage.toCVPixelBuffer()  {
                        do {
                            let prediction = try model.prediction(image: buffer)
                            self.predictions = prediction.targetProbability
                        }catch {
                            print(error.localizedDescription)
                        }
                        }
               
                } label: {
                    Text("Predict")
                }.buttonStyle(.borderedProminent)
                    .tint(.purple)
                    .disabled(uiImage == nil)
                
                if !sortPredictions.isEmpty {
                    List(sortPredictions, id:\.key) { key, value in
                        HStack {
                            Text(key)
                            Spacer()
                            Text(NSNumber(value:value), formatter: NumberFormatter.percent)
                            
                        }
                    }
                }

                Spacer()
                
            }.navigationTitle("Predict Car/Dog")
                .onChange(of: selectedPhotoItem) { _,newValue in
                    Task {
                        if let data = try? await newValue?.loadTransferable(type: Data.self) {
                            self.uiImage = UIImage(data: data)
                        }
                        
                    }
                }.sheet(isPresented: $isCameraPresented) {
                    ImagePicker(image: $uiImage)
                }
        }
    }
}

#Preview {
    ContentView()
}
