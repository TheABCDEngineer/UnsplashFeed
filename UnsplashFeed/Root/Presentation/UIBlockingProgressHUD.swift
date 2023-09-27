import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.show()
    }
    
    static func dismiss() {
        ProgressHUD.dismiss()
        window?.isUserInteractionEnabled = true
    }
}
