//
//  ImagePicker.swift
//  SwiftUI_002
//
//  Created by XIAOFEI MA on 2019/12/24.
//  Copyright © 2019 XIAOFEI MA. All rights reserved.
//

import Foundation
import SwiftUI

class ImagePickerCoorinator: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate
 {
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var uiimage:UIImage?
    @Binding var frombtn: Int
    
    init(isShown: Binding<Bool>, image: Binding<Image?>,frombtn :Binding<Int> ,uiimage: Binding<UIImage?>){
        _isShown = isShown
        _image = image
        _frombtn = frombtn
        _uiimage = uiimage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        uiimage = uiImage
        image = Image(uiImage:uiImage)
        if( saveImage(image: uiImage, fileName: "111113.jpeg")){
            print("save success!!!!")
        }
        isShown = false
        
//        UserList().registRecoImage1(userId: "102800", userName: "消費者",distName: "第２開発部" ,img: uiImage)
//        UserList().recoImageForUserAdd(userId: "102800", userName: "松方", distName: "第二システム開発部", uiImage: uiImage)
        if frombtn == 1 {
            //User addユーザ登録
//            UserList().postImg(userId: "101800", userName: "ま", distName: "test", uiImage: uiImage)
//            UserList().registRecoImage1(userId: "102800", userName: "松方", distName: "第二システム開発部", img: uiImage)
        }
        if frombtn == 2 {
            //入場顔認証
            UserList().recoImage(img: uiImage,status: "0")
//            UserList().getUpdate(userId: "101800")
        }
        if frombtn == 3 {
            //退場
            UserList().recoImage(img: uiImage,status: "1")
        }
        if frombtn == 4 {
            //最終退場
            UserList().recoImage(img: uiImage,status: "2")
        }
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
    
     func saveImage (image: UIImage, fileName: String ) -> Bool{
        //pngで保存する場合
        let pngImageData = image.pngData()
        // jpgで保存する場合
    //    let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        do {
            try pngImageData!.write(to: fileURL)
        } catch {
            //エラー処理
            return false
        }
        return true
    }
}
struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var image: Image?
    @Binding var frombtn: Int
    @Binding var uiimage : UIImage?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    func makeCoordinator() -> ImagePickerCoorinator {
        return ImagePickerCoorinator(isShown: $isShown, image: $image, frombtn: $frombtn,uiimage: $uiimage)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.cameraDevice = .front
        picker.cameraCaptureMode = .photo
        picker.cameraFlashMode = .off
        picker.showsCameraControls = true
        picker.videoQuality = .type640x480
        picker.cameraViewTransform = picker.cameraViewTransform.scaledBy(x: 1, y: -1)
        picker.isEditing = true
        picker.cameraFlashMode = .off
        
        
        return picker
    }
    
    
     func saveImage (image: UIImage, fileName: String ) -> Bool{
        //pngで保存する場合
       let image_new = imageRotatedByDegrees(oldImage: image, deg: 180)
        let pngImageData = image_new.pngData()
        // jpgで保存する場合
    //    let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)
        do {
            try pngImageData!.write(to: fileURL)
        } catch {
            //エラー処理
            return false
        }
        return true
    }
    func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}
