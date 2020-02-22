//
//  ContentView.swift
//  SwiftUI_002
//
//  Created by XIAOFEI MA on 2019/12/24.
//  Copyright © 2019 XIAOFEI MA. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var showImagePicker: Bool = false
    @State private var image:Image? = nil
    @State private var uiimage:UIImage? = nil
    @State private var frombtn:Int = 0
    @State private var showingAlert:Bool = false
    var body: some View {
        
        VStack {
            image?.resizable()
                .scaledToFit()
                .clipShape(Circle())
            Text("入退場管理")
                .font(.largeTitle)
                .lineLimit(0)
                .padding(.top, 17.0)
                .frame(width: 200.0, height: 400.0)
            
            Button("Open Camera"){
                self.showImagePicker = true
            }.padding()
                .background(Color.green)
                .foregroundColor(Color.white)
            .cornerRadius(10)
            
            
      
//        }.sheet(isPresented: self.$showImagePicker){
//            PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image,frombtn: self.$frombtn,uiimage: self.$uiimage)
        }
        
        
    }
}
struct ContentView1: View {
    
    
    var body: some View {
        
       Text(/*@START_MENU_TOKEN@*/"Placeholder"/*@END_MENU_TOKEN@*/)

        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1194, height: 834))
    }
}
