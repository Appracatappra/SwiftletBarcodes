//
//  BarcodeView.swift
//  Stuff To Get
//
//  Created by Kevin Mullins on 6/16/21.
//

import SwiftUI

/**
View designed to display a barcode in SwiftUI. The view will automatically display a black barcode on a white background (for high contrast to make the code more scannable), even in the Dark Theme.

The view can optionally display a large title over the barcode and optionally display a smaller version of the data represented by the barcode underneath it. Several parameters are provided to set the size of the resulting barcode and to style the elements.

## Example:
```swift
let card = store.loyaltyCard
SwiftletBarcodeView(showTitle: true, title:card.name, showData: true, data: card.data, format: card.format, hasDivider: true, width: card.width, height: card.height)
```
 */
public struct SwiftletBarcodeView: View {
    // MARK: - Properties
    /// If `true`, show the large title over the barcode.
    public var showTitle:Bool = true
    
    /// The text for the large title.
    public var title = "Loyalty Card"
    
    /// The color to display the large title in.
    public var titleColor:Color = .black
    
    /// If `true`, display the data represented by the barcode underneath it.
    public var showData:Bool = true
    
    /// The data that the barcode will represent.
    public var data = "1 12208 81912 0"
    
    /// The color to show the represented data in.
    public var dataColor:Color = .black
    
    /// The format of the barcode to generate.
    public var format:SwiftletBarcodes.BarcodeFormat = .code128
    
    /// If `true`, display a `Divider()` before and after the barcode.
    public var hasDivider:Bool = true
    
    /// The width of the barcode to generate.
    public var width:Double = 380
    
    /// The hieght of the barcode to generate.
    public var height:Double = 150
    
    /// Returns the image of the generated barcode.
    public var barcode:Image? {
        return SwiftletBarcodes.generate(from: data, format: format, width: width, height:height)
    }
    
    // MARK: - Initializers
    /// Creates a new instance of the view with the given parameters.
    /// - Parameters:
    ///   - showTitle: If `true`, show a large title over the barcode.
    ///   - title: The title to display.
    ///   - titleColor: The title color.
    ///   - showData: If `true`, Show the data represented by the barcode under it.
    ///   - data: The data for the barcode to represent.
    ///   - dataColor: The color of the represented data.
    ///   - format: The format that the barcode will be generated in.
    ///   - hasDivider: If `true`, display a divider above and below the Barcode Card.
    ///   - width: The width of the generated barcode.
    ///   - height: The height of the generated barcode.
    public init(showTitle:Bool = true, title:String = "Loyalty Card", titleColor:Color = .black, showData:Bool = true, data:String = "1 12208 81912 0", dataColor:Color = .black, format:SwiftletBarcodes.BarcodeFormat = .code128, hasDivider:Bool = true, width:Double = 380, height:Double = 150) {
        // Initialize
        self.showTitle = showTitle
        self.title = title
        self.titleColor = titleColor
        self.showData = showData
        self.data = data
        self.dataColor = dataColor
        self.format = format
        self.hasDivider = hasDivider
        self.width = width
        self.height = height
    }
    
    /// Returns the body of the generated barcode.
    public var body: some View {
        VStack {
            if let barcode = barcode {
                if hasDivider {
                    Divider()
                }
                
                if showTitle {
                    Text(title)
                        .font(.title)
                        .foregroundColor(titleColor)
                }
                    
                barcode
                
                if showData {
                    Text(data)
                        .font(.footnote)
                        .foregroundColor(titleColor)
                }
                
                if hasDivider {
                    Divider()
                }
            }
        }
        .background(Color.white)
    }
}


/// Defines a sample version of the `SwiftletBarcodeView` used during design.
public struct SwiftletBarcodeView_Previews: PreviewProvider {
    /// Returns the sample previews for design.
    public static var previews: some View {
        SwiftletBarcodeView()
    }
}
