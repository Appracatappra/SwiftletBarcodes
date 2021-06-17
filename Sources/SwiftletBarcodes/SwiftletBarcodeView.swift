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
struct SwiftletBarcodeView: View {
    // MARK: - Properties
    /// If `true`, show the large title over the barcode.
    var showTitle:Bool = true
    
    /// The text for the large title.
    var title = "Loyalty Card"
    
    /// The color to display the large title in.
    var titleColor:Color = .black
    
    /// If `true`, display the data represented by the barcode underneath it.
    var showData:Bool = true
    
    /// The data that the barcode will represent.
    var data = "1 12208 81912 0"
    
    /// The color to show the represented data in.
    var dataColor:Color = .black
    
    /// The format of the barcode to generate.
    var format:SwiftletBarcodes.BarcodeFormat = .code128
    
    /// If `true`, display a `Divider()` before and after the barcode.
    var hasDivider:Bool = true
    
    /// The width of the barcode to generate.
    var width:Double = 380
    
    /// The hieght of the barcode to generate.
    var height:Double = 150
    
    /// Returns the image of the generated barcode.
    var barcode:Image? {
        return SwiftletBarcodes.generate(from: data, format: format, width: width, height:height)
    }
    
    /// Returns the body of the generated barcode.
    var body: some View {
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
struct SwiftletBarcodeView_Previews: PreviewProvider {
    /// Returns the sample previews for design.
    static var previews: some View {
        SwiftletBarcodeView()
    }
}
