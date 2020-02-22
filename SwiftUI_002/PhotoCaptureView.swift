//
//  PhotoCaptureView.swift
//  SwiftUI_002
//
//  Created by XIAOFEI MA on 2019/12/24.
//  Copyright © 2019 XIAOFEI MA. All rights reserved.
//

import SwiftUI

struct PhotoCaptureView: View {
    @Binding var showImagePicker: Bool
    @Binding var image:Image?
    @Binding var frombtn: Int
    @Binding var uiimage : UIImage?
    
    var body: some View {
        ImagePicker(isShown: $showImagePicker, image: $image,frombtn: $frombtn,uiimage: $uiimage)
    }
}

#if DEBUG
struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(showImagePicker: .constant(false), image: .constant(Image("")),frombtn: .constant(0),uiimage: .constant(UIImage(contentsOfFile: "")))
    }
}
#endif

