

import UIKit

extension UIImage {
    
    enum JpegQuality: CGFloat {
        case lowest = 0
        case low = 0.25
        case medium = 0.5
        case high = 0.75
        case highest = 1
    }
    
    func jpeg(_ jpegQuality: JpegQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
