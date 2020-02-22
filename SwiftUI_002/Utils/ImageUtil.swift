import Foundation
import UIKit

extension UIImage {
    func resize(scale: CGFloat) -> UIImage? {
        let resized = CGSize(width: size.width * scale, height: size.height * scale)

        UIGraphicsBeginImageContext(resized)
        draw(in: CGRect(origin: .zero, size: resized))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }

    func snip(rect: CGRect) -> UIImage? {
        let croppedImageRef = getUpOrientationImage().cgImage!.cropping(to: rect)!
        return UIImage(cgImage: croppedImageRef)
    }

    func getUpOrientationImage() -> UIImage {
        var fixImage = self
        if imageOrientation != .up {
            UIGraphicsBeginImageContext(size)
            draw(in: CGRect(origin: .zero, size: size))
            fixImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        return fixImage
    }

    func toJpegData(_ quality: Int = -1) -> Data? {
        let q = (quality == -1) ? Setting.getJpegQuality() : quality

        return jpegData(compressionQuality: CGFloat(q) / 100)
    }
}

extension CGRect {
    func convertOrigin(maxSize: CGSize) -> CGRect {
        var rect = self
        rect.origin.y = maxSize.height - rect.origin.y - rect.size.height
        return rect
    }
}

class ImageForAuth {
    public let quality = Setting.getJpegQuality()
    public let snip = Setting.getSnipFace()
    public let resize = Setting.getResizeEnable()
    public let scale = Setting.getResizeRate()
    public var jpegData: Data?

    init(data: Data!) {
        LOG_DEBUG(message: "resize:\(resize) scale:\(scale) snip:\(snip) quality:\(quality)")

        var uiImage = UIImage(data: data)!
        if resize {
            uiImage = uiImage.resize(scale: CGFloat(scale))!
        }
        uiImage = uiImage.getUpOrientationImage()

        if snip {
            let rect = getFaceRect(uiImage)
            if rect == nil {
                LOG_ERROR(message: "CIDetector is failed. So, use raw image.")
            } else {
                uiImage = uiImage.snip(rect: rect!)!
            }
        }

        LOG_DEBUG(message: "image size :\(uiImage.size)")
        jpegData = uiImage.toJpegData(quality)
    }

    func getFaceRect(_ image: UIImage) -> CGRect? {
        let detector = CIDetector(ofType: CIDetectorTypeFace, context: nil)!
        let ciImage = CIImage(cgImage: image.getUpOrientationImage().cgImage!)

        let features = detector.features(in: ciImage)

        let target = features.sorted { (a, b) -> Bool in
            a.bounds.width > b.bounds.width
        }.first

        return target?.bounds.convertOrigin(maxSize: image.size)
    }
}
