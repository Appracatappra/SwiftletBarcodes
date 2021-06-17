//
//  SwiftletBarcodes.swift
//
//  Created by Kevin Mullins on 6/16/21.
//  Based on: https://stackoverflow.com/questions/28542240/how-can-i-generate-a-barcode-from-a-string-in-swift
//  And: https://bestpractiseios.blogspot.com/2018/05/convert-ciimage-to-uiimage-ios-swift.html
//

import Foundation
import CoreGraphics
import SwiftUI

#if os(macOS)
import AppKit
#else
import UIKit
#endif

#if !os(watchOS)
import CoreImage
#endif

/**
Creates a Barcode as a `Image` representing the given data (as a `String`)  in the given `BarcodeFormat`.

There are two forms of the `generate` function:

* One generates the requested barcode at the system specified size.
* The other generates the barcode at a given `width` and `height`.

## Example:
```swift
// At system size
let barcodeA = SwiftletBarcodes.generate(from:"142208819120", format:.code128)

// At a given width and height
let barcodeB = SwiftletBarcodes.generate(from:"142208819120", format:.code128, width:250, height:100)
```
- Remark: NOTE: Generating barcode is NOT supported on watchOS. Calling the `generate` function will always result in a `nil` `Image` being generated.
  */
public class SwiftletBarcodes {
    
    /// Defines the format of the barcode to be generated.
    public enum BarcodeFormat:String, Codable, Equatable, CaseIterable, Identifiable {
        
        /// Sepcifies a type 128 barcode.
        case code128 = "CICode128BarcodeGenerator"
        
        /// Sepcifies a type PDF 417 barcode.
        case pdf417 = "CIPDF417BarcodeGenerator"
        
        /// Sepcifies an Aztec type barcode.
        case aztec = "CIAztecCodeGenerator"
        
        /// Sepcifies a QR Code type barcode.
        case qrCode = "CIQRCodeGenerator"
        
        public var id:String {
            return rawValue
        }
        
        
        /// Sets the enum from the given `String` value.
        /// - Parameter name: The `String` name that matches a case from the enum.
        /// - Remark: Will default to `code128` if the name cannot be found.
        public mutating func fromName(_ name:String) {
            switch(name.lowercased()) {
            case "code128":
                self = .code128
            case "pdf417":
                self = .pdf417
            case "aztec":
                self = .aztec
            case "qrcode":
                self = .qrCode
            default:
                self = .code128
            }
        }
    }
    
    #if os(watchOS)
    /// Generates a barcode in the system specific size for the given text and barcode format.
    /// - Parameters:
    ///   - text: The value that the barcode will represent.
    ///   - format: The format of the barcode to generate.
    /// - Returns: Either an `Image` representing the barcode, or `nil` if the barcode couldn't be generated.
    /// - Remark: NOTE: This function is NOT supported on watchOS and is only included as a stub to support cross platform development.
    public static func generate(from text:String, format:BarcodeFormat) -> Image? {
        // Not supported on watchOS.
        return nil
    }
    #else
    /// Generates a barcode in the system specific size for the given text and barcode format.
    /// - Parameters:
    ///   - text: The value that the barcode will represent.
    ///   - format: The format of the barcode to generate.
    /// - Returns: Either an `Image` representing the barcode, or `nil` if the barcode couldn't be generated.
    public static func generate(from text:String, format:BarcodeFormat) -> Image? {
        
        let formatName = format.rawValue
        
        guard let data = text.data(using: .ascii), let filter = CIFilter(name: formatName) else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        
        guard let image = filter.outputImage else {
            return nil
        }
        
        #if os(macOS)
        return Image(nsImage: toNSImage(from: image))
        #else
        return Image(uiImage: toUIImage(from: image))
        #endif
    }
    #endif
    
    #if os(watchOS)
    /// Generates a barcode at the given widht and height for the given text and barcode format.
    /// - Parameters:
    ///   - text: The value that the barcode will represent.
    ///   - format: The format of the barcode to generate.
    ///   - width: The width of the requested barcode.
    ///   - height: The height of the requested barcode.
    /// - Returns: Either an `Image` representing the barcode, or `nil` if the barcode couldn't be generated.
    /// - Remark: NOTE: This function is NOT supported on watchOS and is only included as a stub to support cross platform development.
    public static func generate(from text:String, format:BarcodeFormat, width:Double, height:Double) -> Image? {
        // Not supported on watchOS.
        return nil
    }
    #else
    /// Generates a barcode at the given widht and height for the given text and barcode format.
    /// - Parameters:
    ///   - text: The value that the barcode will represent.
    ///   - format: The format of the barcode to generate.
    ///   - width: The width of the requested barcode.
    ///   - height: The height of the requested barcode.
    /// - Returns: Either an `Image` representing the barcode, or `nil` if the barcode couldn't be generated.
    public static func generate(from text:String, format:BarcodeFormat, width:Double, height:Double) -> Image? {
        
        let size = CGSize(width: width, height: height)
        let formatName = format.rawValue
        
        guard let data = text.data(using: .ascii), let filter = CIFilter(name: formatName) else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        
        guard let image = filter.outputImage else {
            return nil
        }
        
        let imageSize = image.extent.size
        let transform = CGAffineTransform(scaleX: size.width / imageSize.width, y: size.height / imageSize.height)
        let scaledImage = image.transformed(by: transform)
        
        #if os(macOS)
        return Image(nsImage: toNSImage(from: scaledImage))
        #else
        return Image(uiImage: toUIImage(from: scaledImage))
        #endif
    }
    #endif
    
    #if os(macOS)
    /// Converts a `CIImage` to a `NSImage`.
    /// - Parameter rawImage: The image to convert.
    /// - Returns: The image as a `NSImage`.
    private static func toNSImage(from rawImage:CIImage) -> NSImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(rawImage, from: rawImage.extent)!
        let imageSize = rawImage.extent.size
        let image:NSImage = NSImage.init(cgImage: cgImage, size: NSSize(width: imageSize.width, height: imageSize.height))
        return image
    }
    #elseif !os(watchOS)
    /// Converts a `CIImage` to a `UIImage`.
    /// - Parameter rawImage: The image to convert.
    /// - Returns: The image as a `UIImage`.
    private static func toUIImage(from rawImage:CIImage) -> UIImage {
        let context:CIContext = CIContext.init(options: nil)
        let cgImage:CGImage = context.createCGImage(rawImage, from: rawImage.extent)!
        let image:UIImage = UIImage.init(cgImage: cgImage)
        return image
    }
    #endif
}
