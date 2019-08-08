//
//  UIImage+Rotation.swift
//  OCR test
//
//  Created by Maciej Madaj on 08/08/2019.
//

import UIKit

extension UIImage {
    func fixOrientation() -> UIImage? {
        guard
            let cgImage = cgImage,
            let colorSpace = cgImage.colorSpace
        else {
            return nil
        }

        let width = size.width
        let height = size.height

        var transform: CGAffineTransform = .identity

        switch imageOrientation {
            case .down, .downMirrored:
                transform = transform.translatedBy(x: width, y: height)
                transform = transform.rotated(by: .pi)
            case .left, .leftMirrored:
                transform = transform.translatedBy(x: width, y: 0)
                transform = transform.rotated(by: .pi * 0.5)
            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0, y: height)
                transform = transform.rotated(by: .pi * -0.5)
            case .up, .upMirrored:
                return self
            @unknown default:
                return nil
        }

        guard
            let context = CGContext(
                data: nil,
                width: Int(width),
                height: Int(height),
                bitsPerComponent: cgImage.bitsPerComponent,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: UInt32(cgImage.bitmapInfo.rawValue)
            )
        else {
            return nil
        }

        context.concatenate(transform)

        switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
            default:
                context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }

        guard let newCGImg = context.makeImage() else {
            return nil
        }

        return UIImage(cgImage: newCGImg)
    }
}
