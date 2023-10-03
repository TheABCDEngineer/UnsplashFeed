import UIKit

struct AlertDialogModel {
    let title: String
    let message: String
    let applyTitle: String
    let cancelTitle: String
    let applyAction: (UIAlertAction) -> Void
    let cancelAction: ((UIAlertAction) -> Void)?
}
